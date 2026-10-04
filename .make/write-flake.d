# add write-flake outputs to the porcelain files target
files: flake.nix

# flake dependencies
flake.nix: modules/inputs/cocopilot.nix
flake.nix: modules/inputs/disko.nix
flake.nix: modules/inputs/files.nix
flake.nix: modules/inputs/flake-file.nix
flake.nix: modules/inputs/flake-inputs.nix
flake.nix: modules/inputs/flake-parts.nix
flake.nix: modules/inputs/gnome-shell.nix
flake.nix: modules/inputs/gomod2nix.nix
flake.nix: modules/inputs/home-manager.nix
flake.nix: modules/inputs/import-tree.nix
flake.nix: modules/inputs/lanzaboote.nix
flake.nix: modules/inputs/nix-darwin.nix
flake.nix: modules/inputs/nix-homebrew.nix
flake.nix: modules/inputs/nix-mineral.nix
flake.nix: modules/inputs/nixos-hardware.nix
flake.nix: modules/inputs/nixpkgs.nix
flake.nix: modules/inputs/nur.nix
flake.nix: modules/inputs/sops-nix.nix
flake.nix: modules/inputs/stylix.nix
flake.nix: modules/inputs/systems.nix
flake.nix: modules/inputs/templates.nix
flake.nix: modules/inputs/tinted-theming.nix
flake.nix: modules/inputs/treefmt-nix.nix
flake.nix: modules/inputs/unstable.nix
flake.nix: modules/nix.nix
flake.nix: modules/nix/builders.nix
flake.nix: modules/nix/features.nix
flake.nix: modules/nix/multi-user.nix
flake.nix: modules/nix/packages.nix
flake.nix: modules/nix/substituters.nix
flake.nix: modules/nix/users.nix

# flake recipe
flake.nix:
	nix run .#write-flake
	@touch flake.nix
