{
  lib,
  ...
}:
{
  flake.modules.generic.default = {
    environment.extraOutputsToInstall = [
      "info"
    ];

    environment.variables = {
      EDITOR = "hx";
      ## https://geoff.greer.fm/lscolors/
      ## BSD: LSCOLORS; Linux: LS_COLORS
      LSCOLORS = "exfxcxdxbxeghdabagacad";
      XDG_DATA_DIRS = lib.mkMerge [
        (lib.mkOrder 2000 [
          "/usr/local/share"
          "/usr/share"
        ])
      ];
    };
  };
}
