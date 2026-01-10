{
  lib,
  ...
}:
{
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "resilio-sync"
    ];

  services.resilio = {
    # https://help.resilio.com/hc/en-us/articles/206178884-Running-Sync-in-configuration-mode
    enable = true;
    deviceName = "NAS";
    directoryRoot = "/srv/resilio";
    enableWebUI = true;
    storagePath = "/var/lib/resilio";
    useUpnp = false;
  };

  system.stateVersion = "25.05";
}
