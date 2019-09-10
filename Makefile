SHELL = /bin/sh
DIRECTORIES = $(sort $(wildcard */))
TOOLS = stow fish tmux vim powerline

define stow
	$(info stowing $(subst /,,$(1))...)
	@stow -t ~ -R $(1)
endef

define unstow
	$(info unstowing $(subst /,,$(1))...)
	@stow -t ~ -D $(1)
endef

define drystow
	$(info dry-stowing $(subst /,,$(1))...)
	@stow -t ~ -n $(1)
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

.PHONY: test
test: check
	$(foreach dir,${DIRECTORIES},$(call drystow,${dir}))

.PHONY: check
check:
	$(foreach tool,$(TOOLS),$(call isInstalled,$(tool)))
