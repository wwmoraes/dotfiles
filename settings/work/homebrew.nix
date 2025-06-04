{
  pkgs,
  ...
}:
{
  homebrew.casks = [
    (pkgs.lib.local.globalCask "jabra-direct")
  ];
}
