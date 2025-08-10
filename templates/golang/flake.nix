{
  description = "a shiny new golang project";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-utils = {
      inputs.systems.follows = "systems";
      url = "github:numtide/flake-utils";
    };
    gomod2nix = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:tweag/gomod2nix";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/25.05";
    nur = {
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      url = "github:nix-community/NUR";
    };
    systems.url = "github:nix-systems/default";
    treefmt-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:numtide/treefmt-nix";
    };
    unstable.url = "github:NixOS/nixpkgs";
  };
  nixConfig = {
    extra-substituters = [
      "https://wwmoraes.cachix.org/"
      "https://nix-community.cachix.org/"
    ];
    extra-trusted-public-keys = [
      "wwmoraes.cachix.org-1:N38Kgu19R66Jr62aX5rS466waVzT5p/Paq1g6uFFVyM="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
  outputs =
    inputs@{
      # keep-sorted start
      flake-parts,
      gomod2nix,
      nixpkgs,
      nur,
      self,
      systems,
      treefmt-nix,
      unstable,
      # keep-sorted end
      ...
    }:
    (flake-parts.lib.mkFlake { inherit inputs; } {
      flake = {
        overlays = {
          default = final: prev: {
            inherit (self.packages.${prev.system}) go-hello;
          };
        };
      };

      perSystem =
        {
          # keep-sorted start
          pkgs,
          system,
          # keep-sorted end
          ...
        }:
        let
          treefmt = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
        in
        {
          _module.args.pkgs = import nixpkgs {
            inherit system;
            overlays = [
              gomod2nix.overlays.default
              nur.overlays.default
              self.overlays.default
              (final: prev: {
                unstable = import unstable { inherit (prev) system; };
              })
            ];
            config = { };
          };
          checks.formatting = treefmt.config.build.check self;
          devShells = import ./shell.nix { inherit pkgs; };
          formatter = treefmt.config.build.wrapper;
          packages = rec {
            default = import ./default.nix { inherit pkgs; };
            go-hello = default;
          };
        };
      systems = import systems;
    });
}
