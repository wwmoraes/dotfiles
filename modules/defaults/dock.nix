{
  flake.modules.darwin.default = {
    system.defaults = {
      CustomUserPreferences = {
        "com.apple.dock" = {
          # TODO contribute to system.defaults.dock
          showAppExposeGestureEnabled = true;
          workspaces-auto-swoosh = true;
          wvous-bl-modifier = 0;
          wvous-br-modifier = 0;
          wvous-tl-modifier = 0;
          wvous-tr-modifier = 0;
        };
      };

      dock = {
        autohide = true;
        autohide-delay = 0.0;
        autohide-time-modifier = 0.0;
        dashboard-in-overlay = true;
        enable-spring-load-actions-on-all-items = true;
        expose-animation-duration = 0.1;
        magnification = true;
        mineffect = "genie";
        minimize-to-application = true;
        mouse-over-hilite-stack = true;
        mru-spaces = false;
        show-process-indicators = true;
        show-recents = false;
        showhidden = true;
        tilesize = 72;
        wvous-bl-corner = null;
        wvous-br-corner = null;
        wvous-tl-corner = null;
        wvous-tr-corner = null;
      };
    };
  };
}
