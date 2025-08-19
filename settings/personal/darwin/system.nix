{
  system.defaults = {
    alf = {
      allowdownloadsignedenabled = 1;
      allowsignedenabled = 1;
      globalstate = 1;
      loggingenabled = 1;
      stealthenabled = 1;
    };
    CustomUserPreferences = {
      bluetoothaudiod = {
        "AAC Bitrate" = 320;
        "AAC max packet size" = 644;
        "Apple Bitpool Max" = 80;
        "Apple Bitpool Min" = 80;
        "Apple Initial Bitpool Min" = 80;
        "Apple Initial Bitpool" = 80;
        "Enable AAC codec" = true;
        "Enable AptX codec" = true;
        "Negotiated Bitpool Max" = 80;
        "Negotiated Bitpool Min" = 80;
        "Negotiated Bitpool" = 80;
      };
      "com.apple.BluetoothAudioAgent" = {
        "Apple Bitpool Max (editable)" = 80;
        "Apple Bitpool Min (editable)" = 80;
        "Apple Initial Bitpool (editable)" = 80;
        "Apple Initial Bitpool Min (editable)" = 80;
        "Negotiated Bitpool Max" = 80;
        "Negotiated Bitpool Min" = 80;
        "Negotiated Bitpool" = 80;
        "Stream - Flush Ring on Packet Drop (editable)" = 0;
        "Stream - Max Outstanding Packets (editable)" = 16;
        "Stream Resume Delay" = "0.75";
      };
      "com.apple.commerce" = {
        ## Turn on app auto-update
        AutoUpdate = true;
        ## Disable the App Store to reboot machine on macOS updates
        AutoUpdateRestartRequired = false;
      };
      # "com.apple.mail" = {
      #   AddressesIncludeNameOnPasteboard = false;
      #   ConversationViewSortDescending = true;
      #   DisableInlineAttachmentViewing = true;
      #   DisableReplyAnimations = true;
      #   DisableSendAnimations = true;
      #   DraftsViewerAttributes = {
      #     DisplayInThreadedMode = "yes";
      #     SortedDescending = "no";
      #     SortOrder = "received-date";
      #   };
      #   NSUserKeyEquivalents = {
      #     Send = "@\\U21a9";
      #   };
      #   SpellCheckingBehavior = "NoSpellCheckingEnabled";
      # };
    };
    CustomSystemPreferences = {
      "/Library/Preferences/com.apple.loginwindow" = {
        AdminHostInfo = "HostName";
        TALLogoutSavesState = false;
      };
      "'/Library/Application Support/CrashReporter/DiagnosticMessagesHistory'" = {
        AutoSubmit = false;
        SeedAutoSubmit = false;
        AutoSubmitVersion = 4;
        ThirdPartyDataSubmit = false;
        ThirdPartyDataSubmitVersion = 4;
      };
      "/Library/Preferences/com.apple.iokit.AmbientLightSensor" = {
        "Automatic Display Enabled" = false;
      };
      "/Library/Preferences/com.apple.security.libraryvalidation" = {
        DisableLibraryValidation = true;
      };
      "/Library/Preferences/com.apple.windowserver" = {
        DisplayResolutionEnabled = true;
      };
    };
    loginwindow = {
      DisableConsoleAccess = true;
      GuestEnabled = false;
      LoginwindowText = "Found this? Please contact me on contact@artero.dev";
      PowerOffDisabledWhileLoggedIn = false;
      RestartDisabledWhileLoggedIn = false;
      ShutDownDisabledWhileLoggedIn = false;
    };
    screensaver = {
      askForPassword = true;
      askForPasswordDelay = 0;
    };
    SoftwareUpdate = {
      AutomaticallyInstallMacOSUpdates = true;
    };
  };
}
