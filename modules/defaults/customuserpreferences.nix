{
  flake.modules.darwin.default = {
    system.defaults = {
      CustomUserPreferences = {
        "com.apple.Accessibility" = {
          EnhancedBackgroundContrastEnabled = 1;
        };
        # "com.apple.AddressBook" = {
        #   ABNameSortingFormat = "sortingFirstName sortingLastName";
        #   ABShowDebugMenu = true;
        #   ABDefaultAddressCountryCode = "nl";
        # };
        "com.apple.assistant.support" = {
          "Assistant Enabled" = false;
        };
        "com.apple.CrashReporter" = {
          DialogType = "none";
        };
        "com.apple.desktopservices" = {
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
          UseBareEnumeration = true;
        };
        "com.apple.DiskUtility" = {
          advanced-image-options = true;
          DUDebugMenuEnabled = true;
        };
        "com.apple.dt.Xcode" = {
          XcodeCloudUpsellPromptEnabled = false;
        };
        "com.apple.frameworks.diskimages" = {
          auto-open-ro-root = true;
          auto-open-rw-root = true;
          skip-verify = true;
          skip-verify-locked = true;
          skip-verify-remote = true;
        };
        "com.apple.GameController" = {
          bluetoothPrefsMenuLongPressAction = 0;
          bluetoothPrefsShareLongPressSystemGestureMode = 1;
        };
        # "com.apple.helpviewer" = {
        #   DevMode = true;
        # };
        "com.apple.iCal" = {
          privacyPaneHasBeenAcknowledgedVersion = 4;
          IncludeDebugMenu = true;
          "n days of week" = 7;
          "first day of week" = 0;
          "scroll by weeks in week view" = 1;
          "first minute of work hours" = 540;
          "last minute of work hours" = 1020;
          "number of hours displayed" = 10;
          SharedCalendarNotificationsDisabled = true;
          InvitationNotificationsDisabled = false;
          "Show heat map in Year View" = false;
          OpenEventsInWindowType = false;
          WarnBeforeSendingInvitations = false;
          CalendarSidebarShown = true;
          "add holiday calendar" = true;
          "Default duration in minutes for new event" = 30.0;
          "display birthdays calendar" = true;
          "Show time in Month View" = true;
          "Show Week Numbers" = false;
          "TimeZone support enabled" = true;
          ShowDeclinedEvents = false;
          TimeToLeaveEnabled = true;
        };
        "com.apple.ImageCapture" = {
          disableHotPlug = true;
        };
        "com.apple.messageshelper.MessageController" = {
          SOInputLineSettings = {
            automaticEmojiSubstitutionEnablediMessage = false;
            automaticQuoteSubstitutionEnabled = false;
            continuousSpellCheckingEnabled = false;
          };
        };
        "com.apple.NetworkBrowser" = {
          BrowseAllInterfaces = true;
        };
        "com.apple.print.PrintingPrefs" = {
          "Quit When Finished" = true;
        };
        # "com.apple.QuickTimePlayerX" = {
        #   MGPlayMovieOnOpen = true;
        # };
        "com.apple.ScriptEditor2" = {
          ApplePersistence = false;
        };
        "com.apple.security.authorization" = {
          ignoreArd = true;
        };
        "com.apple.Siri" = {
          StatusMenuVisible = false;
          VoiceTriggerUserEnabled = false;
        };
        "com.apple.SoftwareUpdate" = {
          ## Enable the automatic update check
          AutomaticCheckEnabled = true;
          ## Download newly available updates in background
          AutomaticDownload = 1;
          ## Don't download apps purchased on other Macs
          ConfigDataInstall = 0;
          ## Install System data files & security updates
          CriticalUpdateInstall = 1;
          ## Check for software updates daily, not just once per week
          ScheduleFrequency = 1;
        };
        "com.apple.systemuiserver" = {
          "NSStatusItem Visible com.apple.menuextra.appleuser" = false;
          "NSStatusItem Visible com.apple.menuextra.bluetooth" = false;
          "NSStatusItem Visible com.apple.menuextra.clock" = false;
          "NSStatusItem Visible com.apple.menuextra.volume" = false;
          dontAutoLoad = [
            "/System/Library/CoreServices/Menu Extras/AirPort.menu"
            "/System/Library/CoreServices/Menu Extras/VPN.menu"
            "/System/Library/CoreServices/Menu Extras/WWAN.menu"
            # "/System/Library/CoreServices/Menu Extras/Clock.menu"
            # "/System/Library/CoreServices/Menu Extras/Displays.menu"
            # "/System/Library/CoreServices/Menu Extras/DwellControl.menu"
            # "/System/Library/CoreServices/Menu Extras/Eject.menu"
            # "/System/Library/CoreServices/Menu Extras/ExpressCard.menu"
            # "/System/Library/CoreServices/Menu Extras/GamePolicyExtra.menu"
            # "/System/Library/CoreServices/Menu Extras/PPP.menu"
            # "/System/Library/CoreServices/Menu Extras/PPPoE.menu"
            # "/System/Library/CoreServices/Menu Extras/SafeEjectGPUExtra.menu"
            # "/System/Library/CoreServices/Menu Extras/User.menu"
            # "/System/Library/CoreServices/Menu Extras/Volume.menu"
          ];
        };
        # "com.apple.TextEdit" = {
        #   PlainTextEncoding = 4;
        #   PlainTextEncodingForWrite = 4;
        #   RichText = 0;
        # };
        "com.apple.TextInputMenu" = {
          visible = false;
        };
        # "com.apple.universalaccess" = {
        #   "com.apple.custommenu.apps" = [
        #     # "net.kovidgoyal.kitty"
        #     "NSGlobalDomain"
        #   ];
        #   # reduceTransparency = 1;
        # };
        NSGlobalDomain = {
          ## TODO com.apple.finder.SyncExtensions
          AppleEnableMenuBarTransparency = false;
          CGFontRenderingFontSmoothingDisabled = false;
          NSAllowContinuousSpellChecking = false;
          NSPersonNameDefaultDisplayNameOrder = 1;
          QLPanelAnimationDuration = 0;
          WebKitDeveloperExtras = true;
        };
      };
    };
  };
}
