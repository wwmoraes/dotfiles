# DO-NOT-EDIT. This file was auto-generated using github:vic/flake-file.
# Use `nix run .#write-flake` to regenerate it.
{
  description = "wwmoraes' dotfiles on steroids";

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);

  nixConfig = {
    builders = "ssh-ng://root@vidar aarch64-linux - - - big-parallel,kvm; ssh-ng://root@nas x86_64-linux - - - big-parallel,kvm";
    builders-use-substitutes = true;
    extra-experimental-features = [ "pipe-operators" ];
    extra-substituters = [
      "https://wwmoraes.cachix.org/"
      "https://hercules-ci.cachix.org/"
    ];
    extra-trusted-public-keys = [
      "wwmoraes.cachix.org-1:N38Kgu19R66Jr62aX5rS466waVzT5p/Paq1g6uFFVyM="
      "hercules-ci.cachix.org-1:ZZeDl9Va+xe9j+KqdzoBZMFJHVQ42Uu/c/1/KMC5Lw0="
    ];
    substituters = [
      "https://cache.nixos.org/"
      "https://nix-community.cachix.org/"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    warn-dirty = false;
  };

  inputs = {
    cocopilot = {
      inputs = {
        flake-parts.follows = "flake-parts";
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
        nur.follows = "nur";
        systems.follows = "systems";
        treefmt-nix.follows = "treefmt-nix";
        unstable.follows = "unstable";
      };
      url = "github:wwmoraes/cocopilot";
    };
    disko.url = "github:nix-community/disko";
    files.url = "github:mightyiam/files";
    flake-file.url = "github:vic/flake-file";
    flake-parts = {
      inputs.nixpkgs-lib.follows = "nixpkgs-lib";
      url = "github:hercules-ci/flake-parts";
    };
    flake-utils = {
      inputs.systems.follows = "systems";
      url = "github:numtide/flake-utils";
    };
    gnome-shell = {
      flake = false;
      url = "github:GNOME/gnome-shell";
    };
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager/release-25.11";
    };
    homebrew-brew = {
      flake = false;
      url = "github:Homebrew/brew";
    };
    homebrew-cask = {
      flake = false;
      url = "github:homebrew/homebrew-cask";
    };
    homebrew-core = {
      flake = false;
      url = "github:homebrew/homebrew-core";
    };
    import-tree.url = "github:vic/import-tree";
    lanzaboote = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/lanzaboote/v1.0.0";
    };
    nix-darwin = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
    };
    nix-homebrew = {
      inputs.brew-src.follows = "homebrew-brew";
      url = "github:zhaofengli/nix-homebrew";
    };
    nix-mineral = {
      flake = false;
      url = "github:cynicsketch/nix-mineral";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/release-25.11";
    nixpkgs-lib.follows = "nixpkgs";
    nur = {
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:nix-community/NUR";
    };
    sops-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:Mic92/sops-nix";
    };
    stylix = {
      inputs = {
        flake-parts.follows = "flake-parts";
        gnome-shell.follows = "gnome-shell";
        nixpkgs.follows = "nixpkgs";
        nur.follows = "nur";
        systems.follows = "systems";
      };
      url = "github:danth/stylix/release-25.11";
    };
    systems.url = "github:nix-systems/default";
    templates = {
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        treefmt-nix.follows = "treefmt-nix";
      };
      url = "github:wwmoraes/templates";
    };
    tinted-theming = {
      flake = false;
      url = "github:tinted-theming/schemes/spec-0.11";
    };
    treefmt-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:numtide/treefmt-nix";
    };
    unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    wwmoraes-tap = {
      flake = false;
      url = "github:wwmoraes/homebrew-tap";
    };
  };

}
