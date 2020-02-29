SHELL = /bin/sh
DIRECTORIES = $(sort $(wildcard */))
TOOLS = stow fish tmux vim powerline
OS_DIRECTORIES = $(sort $(patsubst .$(OS)/%,%,$(wildcard .$(OS)/*/)))
HOSTNAME := $(shell hostname -s)
HOST_DIRECTORIES = $(sort $(patsubst .hostnames/$(HOSTNAME)/%,%,$(wildcard .hostnames/$(HOSTNAME)/*/)))

# Detect OS
ifeq ($(OS),Windows_NT)
    OS := windows
else
    OS := $(shell sh -c 'uname 2>/dev/null | tr '[:upper:]' '[:lower:]' || echo unknown')
endif

define stow
	$(info stowing $(subst /,,$(1))...)
	@stow -t ~ -R $(1) 2>&1 \
		| grep -v 'BUG in find_stowed_path?' \
		| grep -v 'WARNING: skipping target which was current stow directory .files' \
		|| true
endef

define unstow
	$(info unstowing $(subst /,,$(1))...)
	@stow -t ~ -D $(1) 2>&1 \
		| grep -v 'BUG in find_stowed_path?' \
		| grep -v 'WARNING: skipping target which was current stow directory .files' \
		|| true
endef

define osstow
	$(info stowing $(OS)/$(subst /,,$(1))...)
	@cd .$(OS) && stow -t ~ -R $(1) 2>&1 \
		| grep -v 'BUG in find_stowed_path?' \
		| grep -v 'WARNING: skipping target which was current stow directory .files' \
		|| true
endef

define osusstow
	$(info unstowing $(OS)/$(subst /,,$(1))...)
	@cd .$(OS) && stow -t ~ -D $(1) 2>&1 \
define hostnamestow
	$(info stowing $(HOSTNAME)/$(subst /,,$(1))...)
	@cd .hostnames/$(HOSTNAME) && stow -t ~ -R $(1) 2>&1 \
		| grep -v 'BUG in find_stowed_path?' \
		| grep -v 'WARNING: skipping target which was current stow directory .files' \
		|| true
endef

define hostnameunstow
	$(info unstowing $(HOSTNAME)/$(subst /,,$(1))...)
	@cd .hostnames/$(HOSTNAME) && stow -t ~ -D $(1) 2>&1 \
		| grep -v 'BUG in find_stowed_path?' \
		| grep -v 'WARNING: skipping target which was current stow directory .files' \
		|| true
endef

define isInstalled
	$(if $(shell which $(1)),,$(warning $(1) isn't installed))
endef

.PHONY: install
install: check
	$(foreach dir,${DIRECTORIES},$(call stow,${dir}))
	$(foreach dir,${OS_DIRECTORIES},$(call osstow,${dir}))
	$(foreach dir,${HOST_DIRECTORIES},$(call hostnamestow,${dir}))

.PHONY: remove
remove: check
	$(foreach dir,${DIRECTORIES},$(call unstow,${dir}))
	$(foreach dir,${OS_DIRECTORIES},$(call osunstow,${dir}))
	$(foreach dir,${HOST_DIRECTORIES},$(call hostnameunstow,${dir}))

.PHONY: check
check:
	$(foreach tool,$(TOOLS),$(call isInstalled,$(tool)))

.PHONY: setup
setup:
	@bash setup.sh
