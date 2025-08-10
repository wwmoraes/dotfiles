MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --no-builtin-variables
.SUFFIXES:

-include .env
-include .env.local

export

-include .make/*.mk

.PHONY: all
all: build bin/hello

.PHONY: build
build:
	@nix build --no-link --print-out-paths

.PHONY: check
check:
	@nix flake check --print-build-logs --verbose

.PHONY: clean
clean:
	-rm -rf bin build

.PHONY: configure
configure:
	cog install-hook --all --overwrite

.PHONY: dist
dist: GOFLAGS=
dist:
	goreleaser release --clean --snapshot --skip archive,before,nfpm,sign --release-notes CHANGELOG.md

.PHONY: release
release:
	cog bump --auto

.PHONY: test
test: ;

## make magic, not war ;)

%/:
	@test -d $@ || mkdir $@
