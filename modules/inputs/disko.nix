{
  inputs,
  lib,
  ...
}:
{
  flake-file = {
    inputs.disko.url = "github:nix-community/disko";
  };

  flake.modules.nixos.default = {
    imports = lib.optionals (inputs ? disko) [
      inputs.disko.nixosModules.disko
    ];
  };
}
