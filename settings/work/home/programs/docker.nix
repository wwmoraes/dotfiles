{
  config,
  lib,
  ...
}:
{
  programs.docker = {
    desktopSettings = {
      FilesharingDirectories = [
        "${config.home.homeDirectory}/workspace"
        "/tmp"
      ];
    };

    settings = lib.mkMerge [
      {
        auths = {
          "p-nexus-3.development.nl.eu.abnamro.com:18443" = { };
          "p-nexus-3.development.nl.eu.abnamro.com:18445" = { };
        };
      }
    ];
  };
}
