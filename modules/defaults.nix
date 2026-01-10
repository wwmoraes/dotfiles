{
  flake.modules.darwin.default =
    {
      pkgs,
      ...
    }:
    rec {
      system.defaults = {
        ActivityMonitor = {
          IconType = 5;
          OpenMainWindow = true;
          ShowCategory = 100;
          SortColumn = "CPUUsage";
          SortDirection = 0;
        };
        CustomUserPreferences = {
          "com.apple.Accessibility" = {
            EnhancedBackgroundContrastEnabled = 1;
          };
          # "com.apple.AddressBook" = {
          #   ABNameSortingFormat = "sortingFirstName sortingLastName";
          #   ABShowDebugMenu = true;
          #   ABDefaultAddressCountryCode = "nl";
          # };
          "com.apple.AppleMultitouchTrackpad" = {
            TrackpadFiveFingerPinchGesture = 2;
            TrackpadFourFingerHorizSwipeGesture = 2;
            TrackpadFourFingerPinchGesture = 2;
            TrackpadFourFingerVertSwipeGesture = 2;
            TrackpadHandResting = true;
            TrackpadHorizScroll = 1;
            TrackpadMomentumScroll = true;
            TrackpadPinch = 1;
            TrackpadRotate = 1;
            TrackpadScroll = true;
            TrackpadThreeFingerVertSwipeGesture = 2;
            TrackpadTwoFingerDoubleTapGesture = 1;
            TrackpadTwoFingerFromRightEdgeSwipeGesture = 3;
          };
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
          "com.apple.dock" = {
            # TODO contribute to system.defaults.dock
            showAppExposeGestureEnabled = true;
            workspaces-auto-swoosh = true;
            wvous-bl-modifier = 0;
            wvous-br-modifier = 0;
            wvous-tl-modifier = 0;
            wvous-tr-modifier = 0;
          };
          "com.apple.driver.AppleBluetoothMultitouch.trackpad" =
            system.defaults.trackpad
            // system.defaults.CustomUserPreferences."com.apple.AppleMultitouchTrackpad";
          "com.apple.dt.Xcode" = {
            XcodeCloudUpsellPromptEnabled = false;
          };
          "com.apple.finder" = rec {
            _FXSortFoldersFirst = true;
            DesktopViewSettings = FK_StandardViewSettings;
            DisableAllAnimations = true;
            FinderSpawnTab = false;
            FK_StandardViewSettings = {
              IconViewSettings = {
                arrangeBy = "grid";
                gridSpacing = 1.0;
                iconSize = 64.0;
                showItemInfo = true;
                # labelOnBottom = false;
              };
            };
            FXEnableRemoveFromICloudDriveWarning = false;
            FXInfoPanesExpanded = {
              General = true;
              MetaData = false;
              Name = true;
              OpenWith = true;
              Preview = false;
              Privileges = false;
            };
            NewWindowTarget = "PfHm";
            NewWindowTargetIsHome = true;
            NewWindowTargetPath = ""; # NewWindowTargetPath: "file://${HOME}/"
            OpenWindowForNewRemovableDisk = true;
            QLEnableTextSelection = true;
            ShowExternalHardDrivesOnDesktop = true;
            ShowHardDrivesOnDesktop = false;
            ShowMountedServersOnDesktop = false;
            ShowRecentTags = false;
            ShowRemovableMediaOnDesktop = true;
            StandardViewSettings = FK_StandardViewSettings;
            WarnOnEmptyTrash = false;
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
          "com.apple.spotlight" = {
            "engagementCount-com.apple.Spotlight.suggestions" = 0;
            EnabledPreferenceRules = [
              "Custom.relatedContents"
              "Domain.IMAGES"
              "Domain.MOVIES"
              "Domain.MUSIC"
              "Domain.PDF"
              "Domain.SOURCE"
              "Domain.SPREADSHEETS"
              "com.apple.AddressBook"
              "com.apple.Photos"
              "com.apple.VoiceMemos"
              "com.apple.podcasts"
              "com.apple.tips"
              "com.surteesstudios.Bartender"
              # "com.getdropbox.dropbox"
              # "com.microsoft.rdc.macos"
              # "com.synology.CloudStationUI"
              # "euronewsuniversal"
              # "net.whatsapp.WhatsApp"
            ];
            orderedItems = [
              {
                enabled = 1;
                name = "APPLICATIONS";
              }
              {
                enabled = 1;
                name = "MENU_EXPRESSION";
              }
              {
                enabled = 1;
                name = "MENU_CONVERSION";
              }
              {
                enabled = 1;
                name = "MENU_DEFINITION";
              }
              {
                enabled = 1;
                name = "SYSTEM_PREFS";
              }
              {
                enabled = 1;
                name = "BOOKMARKS";
              }
              {
                enabled = 1;
                name = "DIRECTORIES";
              }
              {
                enabled = 0;
                name = "PDF";
              }
              {
                enabled = 0;
                name = "FONTS";
              }
              {
                enabled = 0;
                name = "DOCUMENTS";
              }
              {
                enabled = 0;
                name = "MESSAGES";
              }
              {
                enabled = 0;
                name = "CONTACT";
              }
              {
                enabled = 0;
                name = "EVENT_TODO";
              }
              {
                enabled = 0;
                name = "IMAGES";
              }
              {
                enabled = 0;
                name = "MUSIC";
              }
              {
                enabled = 0;
                name = "MOVIES";
              }
              {
                enabled = 0;
                name = "PRESENTATIONS";
              }
              {
                enabled = 0;
                name = "SPREADSHEETS";
              }
              {
                enabled = 0;
                name = "SOURCE";
              }
              {
                enabled = 0;
                name = "MENU_OTHER";
              }
              {
                enabled = 0;
                name = "MENU_WEBSEARCH";
              }
              {
                enabled = 0;
                name = "MENU_SPOTLIGHT_SUGGESTIONS";
              }
            ];
            showedFTE = 1;
            showedLearnMore = 1;
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
          "com.apple.Terminal" = {
            SecureKeyboardEntry = true;
            Shell = "${pkgs.fish}/bin/fish";
            ShowLineMarks = 0;
            StringEncodings = [ "4" ];
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
          "com.google.Chrome.canary" = system.defaults.CustomUserPreferences."org.chromium.Chromium";
          "com.google.Chrome" = system.defaults.CustomUserPreferences."org.chromium.Chromium";
          "org.chromium.Chromium" = {
            AppleEnableMouseSwipeNavigateWithScrolls = false;
            AppleEnableSwipeNavigateWithScrolls = false;
            DisablePrintPreview = true;
            PMPrintingExpandedStateForPrint2 = true;
          };
        };
        CustomSystemPreferences = { };
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
        finder = {
          _FXShowPosixPathInTitle = false;
          AppleShowAllFiles = false;
          FXDefaultSearchScope = "SCcf";
          FXEnableExtensionChangeWarning = false;
          FXPreferredViewStyle = "Nlsv";
          ShowPathbar = true;
          ShowStatusBar = true;
        };
        LaunchServices = {
          LSQuarantine = false;
        };
        NSGlobalDomain = {
          "com.apple.mouse.tapBehavior" = 1;
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
        trackpad = {
          Clicking = false;
          TrackpadRightClick = true;
          TrackpadThreeFingerTapGesture = 2;
        };
        WindowManager = {
          AppWindowGroupingBehavior = false; # one at a time
          EnableTiledWindowMargins = false; # removes margin from tiling
          GloballyEnabled = true; # enables stage manager
        };
      };
    };

  # We cannot use a homeManager module to set targets.darwin as home-manager
  # asserts the host platform to be *-darwin when it is set. Makes one wonder
  # what's even the point of such property then...
  flake.modules.darwin.william = {
    home-manager.users.william = {
      targets.darwin.defaults = {
        "com.apple.CloudSubscriptionFeatures.optIn" = {
          "412681963" = false; # Disable Apple Intelligence (as tested on Tahoe 26.2)
          "545129924" = false; # Disable Apple Intelligence (per https://macos-defaults.com/misc/apple-intelligence.html)
        };
        "com.apple.appstore" = {
          ## Enable Debug Menu in the Mac App Store
          ShowDebugMenu = true;
          ## Enable the WebKit Developer Tools in the Mac App Store
          WebKitDeveloperExtras = true;
        };
      };
    };
  };
}
