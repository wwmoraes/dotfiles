SHELL = /bin/sh
DIRECTORIES = $(sort $(wildcard */))
TOOLS = stow fish tmux vim powerline

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

define isInstalled
	$(if $(shell which $(1)),,$(warning $(1) isn't installed))
endef

.PHONY: install
install: check
	$(foreach dir,${DIRECTORIES},$(call stow,${dir}))

.PHONY: remove
remove: check
	$(foreach dir,${DIRECTORIES},$(call unstow,${dir}))

.PHONY: check
check:
	$(foreach tool,$(TOOLS),$(call isInstalled,$(tool)))

.PHONY: setup
setup:
	@bash setup.sh
