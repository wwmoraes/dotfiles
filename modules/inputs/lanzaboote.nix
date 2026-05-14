{
  inputs,
  lib,
  ...
}:
{
  flake-file.inputs.lanzaboote = {
    url = "github:nix-community/lanzaboote/v1.0.0";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.nixos.default = {
    imports = lib.optionals (inputs ? lanzaboote) [
      inputs.lanzaboote.nixosModules.lanzaboote
    ];
  };
}
