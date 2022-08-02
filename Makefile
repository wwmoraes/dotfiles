SHELL = /bin/sh
TOOLS = stow fish tmux vim

HOSTNAME := $(shell hostname -s)
DIRECTORIES = $(sort $(wildcard */))
OS_DIRECTORIES = $(sort $(patsubst .systems/$(OS)/%,%,$(wildcard .systems/$(OS)/*/)))
HOST_DIRECTORIES = $(sort $(patsubst .hostnames/$(HOSTNAME)/%,%,$(wildcard .hostnames/$(HOSTNAME)/*/)))

CODE = $(shell which code | which code-oss | which codium)
CODE_INSTALLED_EXTENSIONS = $(shell ${CODE} --list-extensions | tr '[:upper:]' '[:lower:]' | sort)
CODE_GLOBAL_EXTENSIONS = $(shell cat .setup.d/packages/code.txt)
CODE_GLOBAL_EXTENSIONS_REMOVE = $(shell cat .setup.d/packages/code-remove.txt)
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
	@echo ${CODE_GLOBAL_EXTENSIONS} | tr ' ' '\n' | grep -E "^-" | cut -d- -f2- >> .setup.d/packages/code-remove.txt
	@cat .setup.d/packages/code-remove.txt | sort -u | sponge .setup.d/packages/code-remove.txt
	@echo ${CODE_GLOBAL_EXTENSIONS} ${CODE_EXTENSION_LIST} | tr ' ' '\n' | grep -vE "^-" | sort -u > .setup.d/packages/code.txt
	@comm -23 .setup.d/packages/code.txt .setup.d/packages/code-remove.txt | sponge .setup.d/packages/code.txt

.PHONY: code-setup
code-setup: CODE_PENDING=$(filter-out ${CODE_INSTALLED_EXTENSIONS},${CODE_GLOBAL_EXTENSIONS})
code-setup: CODE_REMOVE=$(filter-out ${CODE_GLOBAL_EXTENSIONS_REMOVE},${CODE_INSTALLED_EXTENSIONS})
code-setup:
	@echo ${CODE_PENDING} | xargs -n1 ${CODE} --install-extension
	@echo ${CODE_REMOVE} | xargs -n1 ${CODE} --uninstall-extension


.PHONY: code-status
code-status: CODE_PENDING=$(filter-out ${CODE_INSTALLED_EXTENSIONS},${CODE_GLOBAL_EXTENSIONS})
code-status: CODE_REMOVE=$(filter ${CODE_GLOBAL_EXTENSIONS_REMOVE},${CODE_INSTALLED_EXTENSIONS})
code-status:
	@echo "Pending install:"
	@echo ${CODE_PENDING} | tr ' ' '\n'
	@echo "Pending removal:"
	@echo ${CODE_REMOVE} | tr ' ' '\n'

.PHONY: frun
frun:
	@find .setup.d -name "*.sh" | fzf -m | ifne xargs -I{} env TRACE=0 ./run.sh "{}"

.PHONY: lint
lint:
	@shellcheck $(wildcard *.sh) $(wildcard .setup.d/*.sh) $(wildcard .setup.d/**/*.sh)

.PHONY: chmod
chmod:
	@find .setup.d -type f -name "*.sh" -exec chmod +x {} \;

reorder-packages: $(shell find .setup.d/packages -type f -iname "*.txt")
	$(foreach PACKAGE,$^,$(shell sort -u ${PACKAGE} | sponge ${PACKAGE}))
