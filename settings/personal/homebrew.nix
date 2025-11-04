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
    "duckduckgo"
    "hakuneko"
    "image2icon"
    "keybase"
    "launchcontrol"
    "launchpad-manager"
    "macfuse" # # needed by resilio-sync
    "macpass"
    "mate-translate"
    "msty" # # AI/LLM
    "netnewswire"
    "onyx"
    "plex-htpc"
    "plexamp"
    "racket"
    "raindropio"
    "resilio-sync"
    "soundsource"
    "spotify"
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
    # "Be Focused Pro" = 961632517;
    "CCMenu" = 603117688;
    "DoMarks" = 1518886084;
    "GarageBand" = 682658836;
    # "Just Press Record" = 1033342465;
    "Keynote" = 409183694;
    "Numbers" = 409203825;
    "OmniOutliner" = 1142578772;
    # "OX Drive" = 818195014;
    "Parcel" = 639968404;
    # "Privacy Redirect" = 1578144015;
    "Save to Raindrop.io" = 1549370672;
    "StopTheMadness" = 1376402589;
    "Supernote Partner" = 1494992020;
    # "SwiftoDo Desktop" = 1143641091;
    # "Tampermonkey Classic" = 1482490089;
    "TestFlight" = 899247664;
    "Things" = 904280696;
    # "Userscripts-Mac-App" = 1463298887;
    "WireGuard" = 1451685025;
    "Xcode" = 497799835;
    "iMovie" = 408981434;
    # "uBlacklist for Safari" = 1547912640;
    # keep-sorted end
  };
}
