ifneq (${HOSTNAME},${WORK_HOSTNAME})
all: host/M1Cabuk
all: host/nas
all: host/vidar
# all: vm/folkvangr

.PHONY: install/%

#: Activates configuration over SSH.
install/folkvangr::
	nix run nixpkgs#nixos-rebuild -- switch \
		--build-host root@folkvangr.home.arpa \
		--fast \
		--flake .#folkvangr \
		--target-host root@folkvangr.home.arpa \
		;

#: Activates configuration over SSH.
install/vidar::
	nix run nixpkgs#nixos-rebuild -- switch \
		--build-host root@vidar.home.arpa \
		--fast \
		--flake .#vidar \
		--target-host root@vidar.home.arpa \
		;

#: Activates configuration over SSH.
install/hlin::
	nix run nixpkgs#nixos-rebuild -- switch \
		--build-host root@hlin.home.arpa \
		--fast \
		--flake .#hlin \
		--target-host root@hlin.home.arpa \
		;
endif
