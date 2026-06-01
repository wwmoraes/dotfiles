{
  flake.modules.darwin.default = {
    homebrew.casks = [
      # keep-sorted start
      # keep-sorted end
    ];
  };

  flake.modules.darwin.personal = {
    homebrew.casks = [
      # keep-sorted start
      "android-file-transfer"
      "anytype"
      "app-cleaner" # # Nektony App Cleaner & Uninstaller
      "appcleaner"
      # "bartender"
      "calibre"
      "flux-app"
      "hakuneko"
      "keybase"
      "launchcontrol"
      "macpass"
      "mate-translate"
      "netnewswire"
      "oversight"
      "racket"
      "soundsource"
      "suspicious-package"
      "tiddly"
      "uninstallpkg"
      # keep-sorted end
    ];
  };
}
