{
  inputs,
  lib,
  ...
}:
{
  flake-file.inputs.gomod2nix = {
    inputs.flake-utils.follows = "flake-utils";
    inputs.nixpkgs.follows = "nixpkgs";
    url = "github:nix-community/gomod2nix";
  };

  flake.modules.generic.default = {
    nixpkgs.overlays = lib.optionals (inputs ? gomod2nix) [
      inputs.gomod2nix.overlays.default
    ];
  };
}
