SHELL = /bin/sh
TOOLS = stow fish tmux vim powerline

HOSTNAME := $(shell hostname -s)
DIRECTORIES = $(sort $(wildcard */))
OS_DIRECTORIES = $(sort $(patsubst .systems/$(OS)/%,%,$(wildcard .systems/$(OS)/*/)))
HOST_DIRECTORIES = $(sort $(patsubst .hostnames/$(HOSTNAME)/%,%,$(wildcard .hostnames/$(HOSTNAME)/*/)))

VSCODE_INSTALLED_EXTENSIONS = $(shell code --list-extensions | tr '[:upper:]' '[:lower:]' | sort)
VSCODE_GLOBAL_EXTENSIONS = $(shell cat .setup.d/packages/vscode.txt)
VSCODE_TAGGED_EXTENSIONS = $(shell cat .setup.d/packages/*/vscode.txt)

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
		--no-folding \
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
		--no-folding \
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
		--no-folding \
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

.PHONY: vscode-dump
vscode-dump: VSCODE_EXTENSION_LIST = $(filter-out ${VSCODE_TAGGED_EXTENSIONS},${VSCODE_INSTALLED_EXTENSIONS})
vscode-dump:
	@echo ${VSCODE_EXTENSION_LIST} | tr ' ' '\n' > .setup.d/packages/vscode.txt

.PHONY: vscode-install
vscode-install: VSCODE_PENDING = $(filter-out ${VSCODE_INSTALLED_EXTENSIONS},${VSCODE_GLOBAL_EXTENSIONS})
vscode-install:
	@echo ${VSCODE_PENDING} | xargs -n1 code --install-extension

.PHONY: frun
frun:
	@find .setup.d -name "*.sh" | fzf -m | ifne xargs -I{} env TRACE=0 ./run.sh "{}"

.PHONY: lint
lint:
	@shellcheck $(wildcard *.sh) $(wildcard .setup.d/*.sh) $(wildcard .setup.d/**/*.sh)
