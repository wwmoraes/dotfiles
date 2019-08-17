SHELL = /bin/sh
DIRECTORIES = $(sort $(wildcard */))
TOOLS = stow fish tmux vim powerline

define stow
	$(info stowing $(subst /,,$(1))...)
	@stow $(1)
endef

define unstow
	$(info unstowing $(subst /,,$(1))...)
	@stow -D $(1)
endef

define isInstalled
	$(if $(shell which $(1)),,$(error $(1) isn't installed))
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