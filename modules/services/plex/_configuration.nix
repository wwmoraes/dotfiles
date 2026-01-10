{
  lib,
  ...
}:
{
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "plexmediaserver"
    ];

  services.plex = {
    enable = true;
  };

  system.stateVersion = "25.05";
}
