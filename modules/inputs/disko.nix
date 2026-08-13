{
  inputs,
  lib,
  ...
}:
{
  flake-file = {
    inputs.disko = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/disko";
    };
  };

  flake.modules.nixos.default = {
    imports = lib.optionals (inputs ? disko) [
      inputs.disko.nixosModules.disko
    ];
  };
}
