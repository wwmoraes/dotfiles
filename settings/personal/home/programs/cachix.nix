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
      authToken = ""; # set via CACHIX_AUTH_TOKEN/1password run plugin
      hostname = "https://cachix.org";
      binaryCaches = [ ]; # : List { name : Text, secretKey : Text }
    };
  };
}
