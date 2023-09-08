SHELL = /bin/sh
TOOLS = stow find grep

# Detect OS
ifeq ($(OS),Windows_NT)
	OS := windows
else
	OS := $(shell sh -c 'uname 2>/dev/null | tr '[:upper:]' '[:lower:]' || echo unknown')
endif

HOSTNAME := $(shell hostname -s)
TAGS := $(shell cat .hostnames/${HOSTNAME}/dotfiles/.tagsrc 2> /dev/null || true)

GLOBAL_PACKAGES = $(sort $(patsubst %/,%,$(wildcard */)))
OS_PACKAGES = $(sort $(patsubst %/,%,$(wildcard .systems/${OS}/*/)))
TAG_PACKAGES = $(foreach TAG,${TAGS},$(sort $(patsubst %/,%,$(wildcard .tags/${TAG}/*/))))
HOST_PACKAGES = $(sort $(patsubst %/,%,$(wildcard .hostnames/${HOSTNAME}/*/)))

PACKAGES = ${GLOBAL_PACKAGES} ${OS_PACKAGES} ${TAG_PACKAGES} ${HOST_PACKAGES}

CODE = $(shell which code || which code-oss || which codium)
CODE_INSTALLED_EXTENSIONS = $(shell ${CODE} --list-extensions | tr '[:upper:]' '[:lower:]' | sort)
CODE_GLOBAL_EXTENSIONS = $(shell cat .setup.d/packages/code.txt)
CODE_GLOBAL_EXTENSIONS_REMOVE = $(shell cat .setup.d/packages/code-remove.txt)
CODE_TAGGED_EXTENSIONS = $(shell cat .setup.d/packages/*/code.txt)

NODE_NO_WARNINGS := 1
export NODE_NO_WARNINGS

define stow
	$(info stowing $(patsubst .%,%,$1)...$(if $(shell grep -F "$1" .adopt), +adopt)$(if $(shell grep -F "$1" .no-folding), +no-folding))
	@stow \
		$(if $(shell grep -F "$1" .adopt),--adopt) \
		$(if $(shell grep -F "$1" .no-folding),--no-folding) \
		-d "$(dir $1)" -t ~ -R $(notdir $1) 2>&1 \
		| grep -v 'BUG in find_stowed_path?' \
		| grep -v 'WARNING: skipping target which was current stow directory' \
		| grep -v 'stow: ERROR: stow_contents() called with non-directory path:' \
		|| true
endef

define unStow
	$(info un-stowing $(patsubst .%,%,$1)...)
	@stow \
		-d "$(dir $1)" -t ~ -D $(notdir $1) 2>&1 \
		| grep -v 'BUG in find_stowed_path?' \
		| grep -v 'WARNING: skipping target which was current stow directory' \
		|| true
endef

define isInstalled
	$(if $(shell which $1),,$(warning $1 isn't installed))
endef

.PHONY: install
install: check cleanup
	$(foreach PACKAGE,${PACKAGES},$(call stow,${PACKAGE}))

.PHONY: remove
remove:
	$(foreach PACKAGE,${PACKAGES},$(call unStow,${PACKAGE}))

.PHONY: check
check:
	$(foreach TOOL,${TOOLS},$(call isInstalled,${TOOL}))

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
code-setup: CODE_REMOVE=$(filter ${CODE_GLOBAL_EXTENSIONS_REMOVE},${CODE_INSTALLED_EXTENSIONS})
code-setup:
	@echo ${CODE_PENDING} | xargs -n1 -I% bash -c 'echo "installing %"; ${CODE} --log error --install-extension %'
	@echo ${CODE_REMOVE} | xargs -n1 -I% bash -c 'echo "installing %"; ${CODE} --log error --uninstall-extension %'


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
