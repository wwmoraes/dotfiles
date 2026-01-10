{
  flake.modules.darwin.personal =
    {
      pkgs,
      ...
    }:
    {
      homebrew.casks = [
        (pkgs.lib.local.globalCask "yubico-yubikey-manager")
      ];
    };

  flake.modules.homeManager.personal =
    {
      pkgs,
      ...
    }:
    {
      home.packages = [
        pkgs.yubikey-manager
      ];
    };
}
