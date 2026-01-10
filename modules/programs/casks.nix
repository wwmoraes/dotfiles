{
  flake.modules.darwin.default = {
    homebrew.casks = [
      # keep-sorted start
      "anytype"
      "automatic-mouse-mover"
      "bartender"
      "flux-app"
      # keep-sorted end
    ];
  };

  flake.modules.darwin.personal = {
    homebrew.casks = [
      # keep-sorted start
      "android-file-transfer"
      "app-cleaner" # # Nektony App Cleaner & Uninstaller
      "appcleaner"
      "calibre"
      "hakuneko"
      "keybase"
      "launchcontrol"
      "macpass"
      "mate-translate"
      "netnewswire"
      "oversight"
      "racket"
      "raindropio"
      "soundsource"
      "suspicious-package"
      "tiddly"
      "uninstallpkg"
      # keep-sorted end
    ];
  };
}
