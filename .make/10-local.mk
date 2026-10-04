dep:: .make/kernel.local

.make/kernel.local: KERNEL_NAME = $(shell uname -s)
.make/kernel.local: KERNEL_VERSION = $(shell uname -v)
.make/kernel.local:
	$(file >$@)
	$(file >>$@,IS_DARWIN = $(if $(shell echo '${KERNEL_NAME}' | grep Darwin),1,0))
	$(file >>$@,IS_NIXOS = $(if $(shell echo '${KERNEL_NAME}' | grep -q Linux && echo '${KERNEL_VERSION}' | grep NixOS),1,0))
	$(file >>$@,IS_LINUX = $(if $(shell echo '${KERNEL_NAME}' | grep -q Linux && echo '${KERNEL_VERSION}' | grep -v NixOS),1,0))
	@touch $@
	@echo $@ generated

dep:: .make/hostname.local

.make/hostname.local:
	$(file >$@)
	$(file >>$@,HOSTNAME = $(shell uname -n))
	@touch $@
	@echo $@ generated
