MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --no-builtin-variables
.SHELLFLAGS := -euc
export SHELL := $(shell which bash)

.SUFFIXES:

HOSTNAME ?= $(shell uname -n)
NIX_SOURCES = $(sort $(shell git ls-files '*.nix'))

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

dist:
	git archive --prefix=dotfiles/ --output=.tmp/dotfiles-HEAD.tar.gz HEAD

.PHONY: install
#: Applies the current host's settings.
install: host/${HOSTNAME}
ifeq ($(shell uname -s),Darwin)
	sudo darwin-rebuild switch ${FLAGS} --flake .
else
	sudo nixos-rebuild switch ${FLAGS} --flake .
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

restart-nix-daemon:
	sudo launchctl stop org.nixos.nix-daemon
	sudo launchctl start org.nixos.nix-daemon
