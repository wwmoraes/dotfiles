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
    # keep-sorted start
    pkgs.coreutils # # TODO lcoreutils program
    # pkgs.envsubst # # TODO envsubst program from gettext, the OG
    pkgs.expect # # TODO expect program
    pkgs.fd # # TODO fd program
    pkgs.fswatch # # TODO fswatch program
    pkgs.gawk # # TODO gawk program
    pkgs.graphviz # # TODO graphviz program
    # pkgs.dot-language-server ## TODO graphviz program
    pkgs.moreutils # # TODO moreutils program
    pkgs.nix-index
    pkgs.ripgrep # # TODO ripgrep program
    pkgs.tlrc # # TODO tlrc program
    # keep-sorted end
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
