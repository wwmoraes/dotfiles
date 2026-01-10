{
  flake.modules.darwin.default = {
    home-manager.sharedModules = [
      (
        {
          config,
          lib,
          ...
        }:
        {
          home.activation.cleanup = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            echo >&2 "removing old files..."
            run rm -f '${config.home.homeDirectory}/Library/LaunchAgents/dev.artero.hidutil.BTRemoteShutter.plist'
          '';
          # https://gist.github.com/paultheman/808be117d447c490a29d6405975d41bd
          # https://hidutil-generator.netlify.app/
          launchd.agents.bluetooth-remote = {
            enable = true;
            config = {
              Label = "org.nix-community.home.bluetooth-remote";
              LaunchEvents = {
                "com.apple.iokit.matching" = {
                  "com.apple.bluetooth.hostController" = {
                    IOMatchLaunchStream = true;
                    IOProviderClass = "IOBluetoothHCIController";
                    idProduct = 12850; # 0x3232
                    idVendor = 1452; # 0x5ac
                  };
                };
              };
              # hidutil property --matching '{"VendorID":1452,"ProductID":12850}' --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingDst":30064771152,"HIDKeyboardModifierMappingSrc":30064771112},{"HIDKeyboardModifierMappingDst":30064771151,"HIDKeyboardModifierMappingSrc":51539607785}]}''
              # hidutil property --matching '{"ProductID":12850,"VendorID":1452}' --get "UserKeyMapping"
              ProgramArguments = [
                ## TODO https://github.com/snosrap/xpc_set_event_stream_handler
                # "/usr/local/bin/xpc_set_event_stream_handler"
                "/usr/bin/hidutil"
                "property"
                "--matching"
                (builtins.toJSON {
                  VendorID = 1452; # 0x5ac
                  ProductID = 12850; # 0x3232
                })
                "--set"
                (builtins.toJSON {
                  UserKeyMapping = [
                    {
                      HIDKeyboardModifierMappingSrc = 30064771112; # 0x700000028 return_or_enter
                      HIDKeyboardModifierMappingDst = 30064771152; # 0x700000050 left_arrow
                    }
                    {
                      HIDKeyboardModifierMappingSrc = 51539607785; # 0xC000000E9 volume_increment
                      HIDKeyboardModifierMappingDst = 30064771151; # 0x70000004F right_arrow
                    }
                  ];
                })
              ];
              RunAtLoad = true;
            };
          };

          targets.darwin.defaults.NSGlobalDomain = {
            ## To find apps with custom hotkeys set:
            ##   defaults find NSUserKeyEquivalents
            ##   defaults read com.apple.universalaccess com.apple.custommenu.apps
            ## Syntax:
            ##   command = @
            ##   control = ^
            ##   option = ~
            ##   shift = $
            NSUserKeyEquivalents = {
              "Enter Full Screen" = "@^f";
              "Return to Previous Size" = "";
              Bottom = "^$↓"; # U+2193
              "Bottom & Quarters" = "";
              "Bottom & Top" = "~^$↓"; # U+2193
              "Left & Quarters" = "";
              "Left & Right" = "~^$←"; # U+2190
              "Right & Left" = "~^$→"; # U+2192
              "Right & Quarters" = "";
              "Top & Bottom" = "~^$↑"; # U+2191
              "Top & Quarters" = "";
              Centre = "^$c";
              Fill = "^$f";
              Left = "^$←"; # U+2190
              Right = "^$→"; # U+2192
              Top = "^$↑"; # U+2191
            };
          };
        }
      )
    ];

    system.hotkeys =
      {
        hotkey,
        actions,
        keys,
        modifiers,
      }:
      {
        "${actions.FocusMenuBar}" = hotkey true keys.F2 (modifiers.Fn + modifiers.Control);
        "${actions.FocusDock}" = hotkey true keys.F3 (modifiers.Fn + modifiers.Control);
        "${actions.FocusWindow}" = hotkey true keys.F4 (modifiers.Fn + modifiers.Control);
        "${actions.FocusWindowToolbar}" = hotkey true keys.F5 (modifiers.Fn + modifiers.Control);
        # "11"  = hotkey true keys.F6 (modifiers.Fn + modifiers.Control);
        # "12"  = hotkey true keys.F1 (modifiers.Fn + modifiers.Control);
        # "13"  = hotkey true keys.F7 (modifiers.Fn + modifiers.Control);
        # "15"  = hotkey false keys.Number8 (modifiers.Option + modifiers.Command);
        # "17"  = hotkey false 61 24 (modifiers.Option + modifiers.Command);
        # "19"  = hotkey false 45 27 (modifiers.Option + modifiers.Command);
        # "21"  = hotkey true keys.Number8 (modifiers.Control + modifiers.Option + modifiers.Command);
        # "23"  = hotkey false 92 42 (modifiers.Option + modifiers.Command);
        # "25"  = hotkey true 46 47 (modifiers.Control + modifiers.Option + modifiers.Command);
        # "26"  = hotkey true 44 43 (modifiers.Control + modifiers.Option + modifiers.Command);
        # "27"  = hotkey true 96 50 modifiers.Command;
        # "28"  = hotkey true 51 20 (modifiers.Shift + modifiers.Command);
        # "29"  = hotkey true 51 20 (modifiers.Shift + modifiers.Control + modifiers.Command);
        # "30"  = hotkey true 52 21 (modifiers.Shift + modifiers.Command);
        # "31"  = hotkey true 52 21 (modifiers.Shift + modifiers.Control + modifiers.Command);
        # "32"  = hotkey false 126 (modifiers.Fn + modifiers.Control);
        # "33"  = { enabled = false; };
        # "34"  = hotkey false 126 (modifiers.Fn + modifiers.Shift + modifiers.Control);
        # "35"  = { enabled = false; };
        # "36"  = { enabled = false; };
        # "37"  = { enabled = false; };
        # "45"  = { enabled = false; };
        # "47"  = { enabled = false; };
        # "48"  = { enabled = false; };
        # "49"  = { enabled = false; };
        # "52"  = hotkey false 100 2 (modifiers.Option + modifiers.Command);
        # "57"  = hotkey true 100 (modifiers.Fn + modifiers.Control);
        # "59"  = hotkey true 96 (modifiers.Fn + modifiers.Command);
        # "60"  = hotkey true 96 50 (modifiers.Shift + modifiers.Control);
        # "61"  = hotkey false 32 49 (modifiers.Control + modifiers.Option);
        # "64"  = hotkey true 49 modifiers.Command;
        # "65"  = hotkey true 49 (modifiers.Option + modifiers.Command);
        "79" = hotkey false keys.LeftArrow (modifiers.Shift + modifiers.Option);
        "80" = hotkey false keys.LeftArrow (modifiers.Shift + modifiers.Control + modifiers.Option);
        "81" = hotkey false keys.RightArrow (modifiers.Shift + modifiers.Option);
        "82" = hotkey false keys.RightArrow (modifiers.Shift + modifiers.Control + modifiers.Option);
        # "98"  = hotkey true 47 44 (modifiers.Shift + modifiers.Command);
        # "118" = hotkey false 18 modifiers.Control;
        # "119" = hotkey false 19 modifiers.Control;
        # "160" = hotkey false keys.None modifiers.None;
        # "162" = hotkey true keys.F5 (modifiers.Fn + modifiers.Option + modifiers.Command);
        # "163" = hotkey false keys.None modifiers.None;
        # "164" = { enabled = true; value = { parameters = [ 262144 4294705151 ]; type = "modifiers"; }; };
        # "175" = hotkey false keys.None modifiers.None;
        # "179" = hotkey false keys.None modifiers.None;
        # "181" = hotkey true 54 22 (modifiers.Shift + modifiers.Command);
        # "182" = hotkey true 54 22 (modifiers.Shift + modifiers.Control + modifiers.Command);
        # "184" = hotkey true 53 23 (modifiers.Shift + modifiers.Command);
        # "190" = hotkey true 113 12 modifiers.Fn;
        # "222" = hotkey true keys.None modifiers.None;
      };
  };
}
