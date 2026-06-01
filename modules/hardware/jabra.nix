{
  flake.modules.darwin.personal =
    {
      pkgs,
      ...
    }:
    {
      homebrew.casks = [
        (pkgs.lib.local.globalCask "jabra-direct")
      ];
    };
}
