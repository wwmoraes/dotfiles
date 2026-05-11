ifneq (${HOSTNAME},${WORK_HOSTNAME})
all: host/M1Cabuk
all: host/nas
all: host/vidar
# all: vm/folkvangr

.PHONY: install/%

#: Activates configuration over SSH.
install/vidar::
	nix run nixpkgs#nixos-rebuild -- switch \
		--build-host root@vidar.home.arpa \
		--fast \
		--flake .#vidar \
		--target-host root@vidar.home.arpa \
		;
endif
