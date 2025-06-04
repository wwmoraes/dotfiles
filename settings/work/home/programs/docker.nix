{
  lib,
  ...
}:
{
  programs.docker = {
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
