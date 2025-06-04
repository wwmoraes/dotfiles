{
  lib,
  pkgs,
  ...
}:
{
  home.packages = [
    pkgs.cachix
  ];

  xdg.configFile."cachix/cachix.dhall" = {
    text = lib.generators.toDhall { } {
      hostname = "https://cachix.org";
    };
  };
}
