# DO-NOT-EDIT. This file was auto-generated using github:mightyiam/files.
# Use `nix run .#write-files` to regenerate it.

.PHONY: install/folkvangr
#: Activates configuration over SSH.
install/folkvangr::
	nix run nixpkgs#nixos-rebuild -- switch --build-host root@folkvangr.home.arpa --fast --flake .#folkvangr --target-host root@folkvangr.home.arpa

.PHONY: install/hlin
#: Activates configuration over SSH.
install/hlin::
	nix run nixpkgs#nixos-rebuild -- switch --build-host root@hlin.home.arpa --fast --flake .#hlin --target-host root@hlin.home.arpa

.PHONY: install/vidar
#: Activates configuration over SSH.
install/vidar::
	nix run nixpkgs#nixos-rebuild -- switch --build-host root@vidar.home.arpa --fast --flake .#vidar --target-host root@vidar.home.arpa
