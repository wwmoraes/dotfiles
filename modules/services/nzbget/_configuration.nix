{
  lib,
  ...
}:
{
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "unrar"
    ];

  services.nzbget = {
    enable = true;
  };

  system.stateVersion = "25.05";
}
