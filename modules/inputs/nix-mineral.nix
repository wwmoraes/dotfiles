{
  inputs,
  lib,
  ...
}:
{
  flake-file.inputs.nix-mineral = {
    url = "github:cynicsketch/nix-mineral";
    flake = false;
  };

  flake.modules.nixos.hardening = {
    imports = lib.optionals (inputs ? nix-mineral) [
      (inputs.nix-mineral + /nix-mineral.nix)
    ];

    nix-mineral = {
      enable = true;
      overrides = {
        security = {
          disable-bluetooth-kmodules = true;
        };
      };
    };
  };
}
