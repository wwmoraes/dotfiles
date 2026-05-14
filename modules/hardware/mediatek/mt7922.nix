{
  lib,
  ...
}:
{
  flake.nixosModules.mt7922 =
    {
      config,
      ...
    }:
    {
      boot = {
        extraModprobeConfig = ''
          options cfg80211 ieee80211_regdom="${config.networking.wireless.iwd.settings.General.Country}"
        '';
        kernelParams = [
          # https://github.com/NixOS/nixpkgs/issues/448088#issuecomment-3366937219
          "mt7921_common.disable_clc=1"
        ];
      };

      hardware.wirelessRegulatoryDatabase = true;

      networking.wireless.iwd.settings.General.Country = lib.mkDefault "UN";
    };
}
