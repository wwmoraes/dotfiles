{
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkMerge
    mkOrder
    ;
  mkSystem = mkOrder 2000;
in
{
  environment.extraOutputsToInstall = [
    "info"
  ];

  environment.systemPackages = [
    pkgs.coreutils # # TODO lcoreutils program
    pkgs.envsubst # # TODO envsubst program
    pkgs.expect # # TODO expect program
    pkgs.fd # # TODO fd program
    pkgs.fswatch # # TODO fswatch program
    pkgs.gawk # # TODO gawk program
    pkgs.graphviz # # TODO graphviz program
    pkgs.moreutils # # TODO moreutils program
    pkgs.ripgrep # # TODO ripgrep program
    pkgs.tlrc # # TODO tlrc program
    pkgs.yazi # # TODO yazi program
  ];

  environment.systemPath = mkMerge [
    # (lib.mkOrder 1100 (readPathsFromFiles (listDirRegularPaths /etc/paths.d)))
    (mkOrder 1100 [
      "/Library/Apple/usr/bin" # # rvictl
      # "/Applications/Keybase.app/Contents/SharedSupport/bin" ## TODO Keybase
      # "/Library/TeX/texbin" ## TODO tex path
    ])
    (mkOrder 1200 [ "/usr/local/sbin" ])
  ];

  environment.variables = {
    EDITOR = "hx";
    ## https://geoff.greer.fm/lscolors/
    ## BSD: LSCOLORS; Linux: LS_COLORS
    LSCOLORS = "exfxcxdxbxeghdabagacad";
    MANPAGER = "less";
    PAGER = "less";
    XDG_DATA_DIRS = mkMerge [
      (mkSystem [
        "/usr/local/share"
        "/usr/share"
      ])
    ];
  };
}
