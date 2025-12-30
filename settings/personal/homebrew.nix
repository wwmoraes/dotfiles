{
  pkgs,
  ...
}:
{
  homebrew.casks = [
    # keep-sorted start
    "android-file-transfer"
    "app-cleaner" # # Nektony App Cleaner & Uninstaller
    "appcleaner"
    "calibre"
    "hakuneko"
    "image2icon"
    "keybase"
    "launchcontrol"
    "macfuse" # # needed by resilio-sync
    "macpass"
    "mate-translate"
    "msty" # # AI/LLM
    "netnewswire"
    "orion"
    "oversight"
    "plex-htpc"
    "plexamp"
    "racket"
    "raindropio"
    "resilio-sync"
    "soundsource"
    "suspicious-package"
    "thingsmacsandboxhelper"
    "tiddly"
    "uninstallpkg"
    # keep-sorted end
    (pkgs.lib.local.globalCask "yubico-yubikey-manager")
  ];

  homebrew.masApps = {
    # keep-sorted start
    "Apple Configurator" = 1037126344;
    "CCMenu" = 603117688;
    "DoMarks" = 1518886084;
    "GarageBand" = 682658836;
    "Keynote" = 409183694;
    "Numbers" = 409203825;
    "OmniOutliner" = 1142578772;
    "Save to Raindrop.io" = 1549370672;
    "StopTheMadness" = 1376402589;
    "TestFlight" = 899247664;
    "Things" = 904280696;
    "WireGuard" = 1451685025;
    "Xcode" = 497799835;
    "iMovie" = 408981434;
    # keep-sorted end
  };
}
