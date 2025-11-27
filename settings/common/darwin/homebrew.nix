{
  config,
  lib,
  pkgs,
  ...
}:
{
  homebrew.brews =
    let
      hasApps = (builtins.length (builtins.attrNames config.homebrew.masApps)) > 0;
      hasTaps = (builtins.length config.homebrew.taps) > 0;
    in
    lib.mkMerge [
      (lib.optional hasApps "mas") # # used internally by brew masApps
      (lib.optional hasTaps "gh") # # used internally by brew taps
      [
        # keep-sorted start
        "qcachegrind"
        # keep-sorted end
      ]
    ];

  homebrew.casks = [
    # keep-sorted start
    "anytype"
    "automatic-mouse-mover"
    "bartender"
    "bruno"
    "das-keyboard-q"
    "displaylink-login-screen-ext"
    "elgato-stream-deck"
    "flux-app"
    "sqlitestudio"
    # keep-sorted end
    (pkgs.lib.local.globalCask "displaylink-manager")
  ];

  homebrew.taps = [
    "homebrew/bundle"
    "homebrew/services"
    "wwmoraes/tap"
  ];
}
