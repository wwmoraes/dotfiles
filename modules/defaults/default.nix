{
  flake.modules.darwin.default = {
    system.defaults = {
      ActivityMonitor = {
        IconType = 5;
        OpenMainWindow = true;
        ShowCategory = 100;
        SortColumn = "CPUUsage";
        SortDirection = 0;
      };
      LaunchServices = {
        LSQuarantine = false;
      };
      NSGlobalDomain = {
        "com.apple.sound.beep.feedback" = 0;
        "com.apple.springing.delay" = 0.0;
        "com.apple.springing.enabled" = true;
        # NSTextInsertionPointBlinkPeriod = 9999999999999999;
        AppleFontSmoothing = 1;
        AppleInterfaceStyle = "Dark";
        AppleInterfaceStyleSwitchesAutomatically = false;
        AppleKeyboardUIMode = 3;
        AppleMeasurementUnits = "Centimeters";
        AppleMetricUnits = 1;
        ApplePressAndHoldEnabled = false;
        AppleShowAllExtensions = false;
        AppleShowScrollBars = "WhenScrolling";
        AppleWindowTabbingMode = "always";
        InitialKeyRepeat = 15;
        KeyRepeat = 4;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSAutomaticWindowAnimationsEnabled = false;
        NSDisableAutomaticTermination = true;
        NSDocumentSaveNewDocumentsToCloud = false;
        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;
        NSScrollAnimationEnabled = true;
        NSTableViewDefaultSizeMode = 2;
        NSTextShowsControlCharacters = true;
        NSUseAnimatedFocusRing = false;
        NSWindowResizeTime = 0.001;
        PMPrintingExpandedStateForPrint = true;
        PMPrintingExpandedStateForPrint2 = true;
      };
      screencapture = {
        disable-shadow = true;
        location = "~/Library/Mobile Documents/com~apple~CloudDocs/Screenshots";
        type = "png";
      };
      WindowManager = {
        AppWindowGroupingBehavior = false; # one at a time
        EnableTiledWindowMargins = false; # removes margin from tiling
        GloballyEnabled = true; # enables stage manager
      };
    };
  };
}
