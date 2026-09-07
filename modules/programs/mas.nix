{
  flake.modules.darwin.default = {
    # We cannot use a homeManager module to set targets.darwin as home-manager
    # asserts the host platform to be *-darwin when it is set. Makes one
    # wonder what's even the point of such property then...
    home-manager.sharedModules = [
      {
        targets.darwin.defaults = {
          "com.apple.appstore" = {
            ## Enable Debug Menu in the Mac App Store
            ShowDebugMenu = true;
            ## Enable the WebKit Developer Tools in the Mac App Store
            WebKitDeveloperExtras = true;
          };
        };
      }
    ];
  };

  flake.modules.darwin.personal = {
    homebrew.masApps = {
      # keep-sorted start
      "CCMenu" = 603117688;
      "DoMarks" = 1518886084;
      "Image2Icon" = 992115977;
      "OmniOutliner" = 6474965689;
      "StopTheMadness" = 1376402589;
      "Tampermonkey" = 6738342400;
      "WireGuard" = 1451685025;
      # keep-sorted end
    };
  };
}
