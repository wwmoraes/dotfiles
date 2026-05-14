{
  lib,
  ...
}:
{
  flake.modules.nixos.secure-boot =
    {
      pkgs,
      ...
    }:
    {
      boot.lanzaboote = {
        enable = true;
        autoEnrollKeys = {
          enable = true;
          autoReboot = true;
        };
        autoGenerateKeys.enable = true;
        pkiBundle = "/var/lib/sbctl";
      };

      boot.loader.systemd-boot.enable = lib.mkForce false;

      environment.systemPackages = [
        pkgs.sbctl
      ];
    };
}
