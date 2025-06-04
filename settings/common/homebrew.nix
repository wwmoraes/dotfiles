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
    ];

  homebrew.casks = [
    "anytype"
    "automatic-mouse-mover"
    "bartender"
    "bruno"
    "das-keyboard-q"
    "displaylink-login-screen-ext"
    (pkgs.lib.local.globalCask "displaylink-manager")
    "elgato-stream-deck"
    "flux-app"
    "sqlitestudio"
  ];

  homebrew.taps = [
    "homebrew/bundle"
    "homebrew/services"
    "wwmoraes/tap"
  ];
}
