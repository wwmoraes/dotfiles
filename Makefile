MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --no-builtin-variables
.SHELLFLAGS := -euc
export SHELL := $(shell which bash)

.SUFFIXES:

HOSTNAME ?= $(shell uname -n)
NIX_SOURCES = $(sort $(shell git ls-files '*.nix'))
WORK_HOSTNAME := NLLM4000559023

-include .make/*.mk

.DEFAULT_GOAL := host/${HOSTNAME}

.PHONY: all
#: Build all hosts' activation scripts.
all: host/NLLM4000559023

.PHONY: build
#: Build current host's activation script.
build: host/${HOSTNAME}

.PHONY: check
#: Validates repository source healthiness.
check: files .make/checksums/check

.PHONY: clean
#: Removes generated content.
clean:
	-rm -rf .roots 2> /dev/null

.PHONY: install
#: Applies the current host's settings.
install: host/${HOSTNAME}
## why? because "enterprise-grade" environments fuck up SSL and nixpkgs somehow
## and it's not really worth my time to fix such edge-case
ifeq (${HOSTNAME},NLLM4000559023)
	sudo .roots/darwin/NLLM4000559023/activate
else ifeq ($(shell uname -s),Darwin)
	sudo darwin-rebuild switch --no-remote ${FLAGS} --flake .
else
	sudo nixos-rebuild switch --no-remote ${FLAGS} --flake .
endif


.PHONY: pushcheck
pushcheck: all
	@cog check --from-latest-tag
	@test "$$(git show HEAD:secrets.yaml 2>/dev/null | sops filestatus --input-type yaml /dev/stdin)" = '{"encrypted":true}'

################################################################################
# Make magic, not war :)
################################################################################

.make/checksums/check: $(shell git ls-files -- ${GIT_TEXT_SPEC})
	@gitleaks git --pre-commit --redact --staged --verbose --no-banner --log-level warn
	@editorconfig-checker
	@nix flake check
	@mkdir -p $(@D)
	@touch $@


secrets.yaml: secrets.yaml.gotmpl
ifeq ($(shell command -v op),)
	@echo "1password not found, skipping secrets update"
else
	@op inject --force --in-file $< | ifne sops encrypt --filename-override $@ --output $@
endif

