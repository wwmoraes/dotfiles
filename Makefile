SHELL = /bin/sh
TOOLS = stow fish tmux vim

HOSTNAME := $(shell hostname -s)
DIRECTORIES = $(sort $(wildcard */))
OS_DIRECTORIES = $(sort $(patsubst .systems/$(OS)/%,%,$(wildcard .systems/$(OS)/*/)))
HOST_DIRECTORIES = $(sort $(patsubst .hostnames/$(HOSTNAME)/%,%,$(wildcard .hostnames/$(HOSTNAME)/*/)))

CODE_INSTALLED_EXTENSIONS = $(shell code --list-extensions | tr '[:upper:]' '[:lower:]' | sort)
CODE_GLOBAL_EXTENSIONS = $(shell cat .setup.d/packages/code.txt)
CODE_TAGGED_EXTENSIONS = $(shell cat .setup.d/packages/*/code.txt)

NODE_NO_WARNINGS := 1
export NODE_NO_WARNINGS

# Detect OS
ifeq ($(OS),Windows_NT)
    OS := windows
else
    OS := $(shell sh -c 'uname 2>/dev/null | tr '[:upper:]' '[:lower:]' || echo unknown')
endif

define stow
	$(info stowing $(subst /,,$(1))...)
	@stow \
		$(if $(shell grep -F "$(subst /,,$(1))" .adopt),--adopt) \
		$(if $(shell grep -F "$(patsubst %/,,$(1))" .no-folding),--no-folding) \
		-t ~ -R $(1) 2>&1 \
		| grep -v 'BUG in find_stowed_path?' \
		| grep -v 'WARNING: skipping target which was current stow directory' \
		| grep -v 'stow: ERROR: stow_contents() called with non-directory path:' \
		|| true
endef

define unstow
	$(info unstowing $(subst /,,$(1))...)
	@stow -t ~ -D $(1) 2>&1 \
		| grep -v 'BUG in find_stowed_path?' \
		| grep -v 'WARNING: skipping target which was current stow directory' \
		|| true
endef

define osstow
	$(info stowing $(OS)/$(subst /,,$(1))...)
	@cd .systems/$(OS) && stow \
		$(if $(shell grep -F "$(OS)/$(subst /,,$(1))" .adopt),--adopt) \
		$(if $(shell grep -F "$(patsubst %/,,$(1))" .no-folding),--no-folding) \
		-t ~ -R $(1) 2>&1 \
		| grep -v 'BUG in find_stowed_path?' \
		| grep -v 'WARNING: skipping target which was current stow directory' \
		| grep -v 'stow: ERROR: stow_contents() called with non-directory path:' \
		|| true
endef

define osunstow
	$(info unstowing $(OS)/$(subst /,,$(1))...)
	@cd .systems/$(OS) && stow -t ~ -D $(1) 2>&1 \
		| grep -v 'BUG in find_stowed_path?' \
		| grep -v 'WARNING: skipping target which was current stow directory' \
		|| true
endef

define hostnamestow
	$(info stowing $(HOSTNAME)/$(subst /,,$(1))...)
	@cd .hostnames/$(HOSTNAME) && stow \
		$(if $(shell grep -F "$(HOSTNAME)/$(subst /,,$(1))" .adopt),--adopt) \
		$(if $(shell grep -F "$(patsubst %/,,$(1))" .no-folding),--no-folding) \
		-t ~ -R $(1) 2>&1 \
		| grep -v 'BUG in find_stowed_path?' \
		| grep -v 'WARNING: skipping target which was current stow directory' \
		| grep -v 'stow: ERROR: stow_contents() called with non-directory path:' \
		|| true
endef

define hostnameunstow
	$(info unstowing $(HOSTNAME)/$(subst /,,$(1))...)
	@cd .hostnames/$(HOSTNAME) && stow -t ~ -D $(1) 2>&1 \
		| grep -v 'BUG in find_stowed_path?' \
		| grep -v 'WARNING: skipping target which was current stow directory' \
		|| true
endef

define isInstalled
	$(if $(shell which $(1)),,$(warning $(1) isn't installed))
endef

.PHONY: install
install: check cleanup
	$(foreach dir,${DIRECTORIES},$(call stow,${dir}))
	$(foreach dir,${OS_DIRECTORIES},$(call osstow,${dir}))
	$(foreach dir,${HOST_DIRECTORIES},$(call hostnamestow,${dir}))

.PHONY: remove
remove:
	$(foreach dir,${DIRECTORIES},$(call unstow,${dir}))
	$(foreach dir,${OS_DIRECTORIES},$(call osunstow,${dir}))
	$(foreach dir,${HOST_DIRECTORIES},$(call hostnameunstow,${dir}))

.PHONY: check
check:
	$(foreach tool,$(TOOLS),$(call isInstalled,$(tool)))

.PHONY: setup
setup: cleanup
	@sh setup.sh

.PHONY: cleanup
cleanup:
	@find . -name .DS_Store -type f -delete

.PHONY: code-dump
code-dump: CODE_EXTENSION_LIST=$(filter-out ${CODE_TAGGED_EXTENSIONS},${CODE_INSTALLED_EXTENSIONS})
code-dump:
	@echo ${CODE_EXTENSION_LIST} | tr ' ' '\n' > .setup.d/packages/code.txt

.PHONY: code-install
code-install: CODE_PENDING=$(filter-out ${CODE_INSTALLED_EXTENSIONS},${CODE_GLOBAL_EXTENSIONS})
code-install:
	@echo ${CODE_PENDING} | xargs -n1 code --install-extension

.PHONY: frun
frun:
	@find .setup.d -name "*.sh" | fzf -m | ifne xargs -I{} env TRACE=0 ./run.sh "{}"

.PHONY: lint
lint:
	@shellcheck $(wildcard *.sh) $(wildcard .setup.d/*.sh) $(wildcard .setup.d/**/*.sh)

.PHONY: chmod
chmod:
	@find .setup.d -type f -name "*.sh" -exec chmod +x {} \;
