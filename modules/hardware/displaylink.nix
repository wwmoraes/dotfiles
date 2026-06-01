{
  flake.modules.darwin.personal =
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
