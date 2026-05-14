{
  lib,
  ...
}:
{
  flake.modules.nixos.default = {
    system.stateVersion = lib.mkDefault "25.05";
  };

  flake.modules.darwin.default = {
    system.stateVersion = lib.mkDefault 4;
  };
}
