{
  flake.modules.darwin.default = rec {
    system.defaults = {
      CustomUserPreferences = {
        "com.google.Chrome.canary" = system.defaults.CustomUserPreferences."org.chromium.Chromium";
        "com.google.Chrome" = system.defaults.CustomUserPreferences."org.chromium.Chromium";
        "org.chromium.Chromium" = {
          AppleEnableMouseSwipeNavigateWithScrolls = false;
          AppleEnableSwipeNavigateWithScrolls = false;
          DisablePrintPreview = true;
          PMPrintingExpandedStateForPrint2 = true;
        };
      };
    };
  };
}
