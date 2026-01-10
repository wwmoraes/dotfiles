{
  flake.modules.darwin.default =
    {
      pkgs,
      ...
    }:
    {
      homebrew.casks = [
        "displaylink-login-screen-ext"
        (pkgs.lib.local.globalCask "displaylink-manager")
      ];
    };
}
