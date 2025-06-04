{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    ;
  cfg = config.lib.hotkeys;
  standardHotkey = enabled: key: modifiers: {
    inherit enabled;
    value = {
      parameters = [
        key.ascii
        key.code
        modifiers
      ];
      type = "standard";
    };
  };
  addHotkeyScript = action: hotkey: ''
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add ${action} "{ enabled = ${
      lib.trivial.boolToString (hotkey.enabled or false)
    }; value = { parameters = (${
      lib.concatStringsSep "," (map toString (hotkey.value.parameters or [ ]))
    }); type = '${hotkey.value.type or "standard"}'; }; }"
  '';
  hotkeysToScript =
    attrs: lib.mapAttrsToList addHotkeyScript (lib.filterAttrs (n: v: v != null) attrs);
in
{
  meta.maintainers = [
    lib.maintainers.wwmoraes or "wwmoraes"
  ];

  options = {
    # <action:int> = {
    #   enabled = true;
    #   value = {
    #     parameters = [
    #       <ASCII:int>
    #       <keyCode:int>
    #       <modifiers:int>
    #     ];
    #     type = "standard";
    #   };
    # };
    system.hotkeys = mkOption {
      description = "Configures global shortcuts";
      type =
        with types;
        nullOr (oneOf [
          attrs
          (functionTo attrs)
        ]);
      default = null;
      apply =
        x:
        if lib.isFunction x then
          (x {
            hotkey = standardHotkey;
            inherit (cfg) actions;
            inherit (cfg) keys;
            inherit (cfg) modifiers;
          })
        else
          x;
    };
  };

  config = {
    lib.hotkeys = {
      types = rec {
        HotkeyValue =
          with types;
          submodule {
            parameters = mkOption {
              type = listOf ints.unsigned;
            };
            type = mkOption {
              type = nullOr (enum [
                "standard"
                "modifier"
              ]);
              default = "standard";
            };
          };
        Hotkey =
          with types;
          submodule {
            options = {
              enabled = mkOption {
                type = bool;
                default = false;
                description = "Enables this hotkey for use. It still configures regardless.";
              };
              value = mkOption {
                type = nullOr HotkeyValue;
                default = null;
              };
            };
          };
      };

      # https://github.com/NUIKit/CGSInternal/blob/master/CGSHotKeys.h
      actions = {
        # 7
        FocusMenuBar = "7"; # Move focus to the menu bar
        # 8
        FocusDock = "8"; # Move focus to the dock
        # 9
        FocusWindow = "9"; # Move focus to active or next window
        # 10
        FocusWindowToolbar = "10"; # Move focus to window toolbar
        # 11
        FocusFloatingWindow = "11"; # Move focus to floating window
        # 12
        _12 = "12"; # ???
        # 13
        ToggleTabBehaviour = "13"; # Change how tab moves focus
        # 15
        ToggleZoom = "15"; # Toggle zoom
        # 17
        ZoomIn = "17";
        # 19
        ZoomOut = "19";
        # 79
        MoveResizeHalvesLeft = "79";
        # 222
        ToggleStageManager = "222";
      };

      # key codes: https://eastmanreference.com/complete-list-of-applescript-key-codes
      # also https://gist.github.com/jfortin42/68a1fcbf7738a1819eb4b2eef298f4f8
      keys = {
        None = {
          ascii = 65535;
          code = 65535;
        };

        # ascii 009
        Tab = {
          ascii = 9;
          code = 48;
        };
        # ascii 027
        Escape = {
          ascii = 27;
          code = 53;
        };
        # ascii 032
        Space = {
          ascii = 32;
          code = 49;
        };
        # ascii 039
        Quote = {
          ascii = 39;
          code = 39;
        };
        # ascii 044
        Comma = {
          ascii = 44;
          code = 43;
        };
        # ascii 045
        Minus = {
          ascii = 45;
          code = 27;
        };
        # ascii 046
        Period = {
          ascii = 46;
          code = 47;
        };
        # ascii 047
        Slash = {
          ascii = 47;
          code = 44;
        };
        # ascii 048
        Number0 = {
          ascii = 48;
          code = 29;
        };
        # ascii 049
        Number1 = {
          ascii = 49;
          code = 18;
        };
        # ascii 050
        Number2 = {
          ascii = 50;
          code = 19;
        };
        # ascii 051
        Number3 = {
          ascii = 51;
          code = 20;
        };
        # ascii 052
        Number4 = {
          ascii = 52;
          code = 21;
        };
        # ascii 053
        Number5 = {
          ascii = 53;
          code = 23;
        };
        # ascii 054
        Number6 = {
          ascii = 54;
          code = 22;
        };
        # ascii 055
        Number7 = {
          ascii = 55;
          code = 26;
        };
        # ascii 056
        Number8 = {
          ascii = 56;
          code = 28;
        };
        # ascii 057
        Number9 = {
          ascii = 57;
          code = 25;
        };
        # ascii 059
        Semicolon = {
          ascii = 59;
          code = 41;
        };
        # ascii 061
        Equal = {
          ascii = 61;
          code = 24;
        };
        # ascii 091
        LeftBracket = {
          ascii = 91;
          code = 33;
        };
        # ascii 092
        Backslash = {
          ascii = 92;
          code = 42;
        };
        # ascii 093
        RightBracket = {
          ascii = 93;
          code = 30;
        };
        # ascii 096
        Grave = {
          ascii = 96;
          code = 50;
        };
        # ascii 097
        A = {
          ascii = 97;
          code = 0;
        };
        # ascii 098
        B = {
          ascii = 98;
          code = 11;
        };
        # ascii 099
        C = {
          ascii = 99;
          code = 8;
        };
        # ascii 100
        D = {
          ascii = 100;
          code = 2;
        };
        # ascii 101
        E = {
          ascii = 101;
          code = 14;
        };
        # ascii 102
        F = {
          ascii = 102;
          code = 3;
        };
        # ascii 103
        G = {
          ascii = 103;
          code = 5;
        };
        # ascii 104
        H = {
          ascii = 104;
          code = 4;
        };
        # ascii 105
        I = {
          ascii = 105;
          code = 34;
        };
        # ascii 106
        J = {
          ascii = 106;
          code = 38;
        };
        # ascii 107
        K = {
          ascii = 107;
          code = 40;
        };
        # ascii 108
        L = {
          ascii = 108;
          code = 37;
        };
        # ascii 109
        M = {
          ascii = 109;
          code = 46;
        };
        # ascii 110
        N = {
          ascii = 110;
          code = 45;
        };
        # ascii 111
        O = {
          ascii = 111;
          code = 31;
        };
        # ascii 112
        P = {
          ascii = 112;
          code = 35;
        };
        # ascii 113
        Q = {
          ascii = 113;
          code = 12;
        };
        # ascii 114
        R = {
          ascii = 114;
          code = 15;
        };
        # ascii 115
        S = {
          ascii = 115;
          code = 1;
        };
        # ascii 116
        T = {
          ascii = 116;
          code = 17;
        };
        # ascii 117
        U = {
          ascii = 117;
          code = 32;
        };
        # ascii 118
        V = {
          ascii = 118;
          code = 9;
        };
        # ascii 119
        W = {
          ascii = 119;
          code = 13;
        };
        # ascii 120
        X = {
          ascii = 120;
          code = 7;
        };
        # ascii 121
        Y = {
          ascii = 121;
          code = 16;
        };
        # ascii 122
        Z = {
          ascii = 122;
          code = 6;
        };

        # non-ascii 036
        Return = {
          ascii = 65535;
          code = 36;
        };
        # non-ascii 051
        Delete = {
          ascii = 65535;
          code = 51;
        };
        # non-ascii 054
        RightCommand = {
          ascii = 65535;
          code = 54;
        };
        # non-ascii 055
        Command = {
          ascii = 65535;
          code = 55;
        };
        # non-ascii 056
        Shift = {
          ascii = 65535;
          code = 56;
        };
        # non-ascii 057
        CapsLock = {
          ascii = 65535;
          code = 57;
        };
        # non-ascii 058
        Option = {
          ascii = 65535;
          code = 58;
        };
        # non-ascii 059
        Control = {
          ascii = 65535;
          code = 59;
        };
        # non-ascii 060
        RightShift = {
          ascii = 65535;
          code = 60;
        };
        # non-ascii 061
        RightOption = {
          ascii = 65535;
          code = 61;
        };
        # non-ascii 062
        RightControl = {
          ascii = 65535;
          code = 62;
        };
        # non-ascii 063
        Function = {
          ascii = 65535;
          code = 63;
        };
        # non-ascii 064
        F17 = {
          ascii = 65535;
          code = 64;
        };
        # non-ascii 065
        KeypadDecimal = {
          ascii = 65535;
          code = 65;
        };
        # non-ascii 067
        KeypadMultiply = {
          ascii = 65535;
          code = 67;
        };
        # non-ascii 069
        KeypadPlus = {
          ascii = 65535;
          code = 69;
        };
        # non-ascii 071
        KeypadClear = {
          ascii = 65535;
          code = 71;
        };
        # non-ascii 072
        VolumeUp = {
          ascii = 65535;
          code = 72;
        };
        # non-ascii 073
        VolumeDown = {
          ascii = 65535;
          code = 73;
        };
        # non-ascii 074
        Mute = {
          ascii = 65535;
          code = 74;
        };
        # non-ascii 075
        KeypadDivide = {
          ascii = 65535;
          code = 75;
        };
        # non-ascii 076
        KeypadEnter = {
          ascii = 65535;
          code = 76;
        };
        # non-ascii 078
        KeypadMinus = {
          ascii = 65535;
          code = 78;
        };
        # non-ascii 079
        F18 = {
          ascii = 65535;
          code = 79;
        };
        # non-ascii 080
        F19 = {
          ascii = 65535;
          code = 80;
        };
        # non-ascii 081
        KeypadEquals = {
          ascii = 65535;
          code = 81;
        };
        # non-ascii 082
        Keypad0 = {
          ascii = 65535;
          code = 82;
        };
        # non-ascii 083
        Keypad1 = {
          ascii = 65535;
          code = 83;
        };
        # non-ascii 084
        Keypad2 = {
          ascii = 65535;
          code = 84;
        };
        # non-ascii 085
        Keypad3 = {
          ascii = 65535;
          code = 85;
        };
        # non-ascii 086
        Keypad4 = {
          ascii = 65535;
          code = 86;
        };
        # non-ascii 087
        Keypad5 = {
          ascii = 65535;
          code = 87;
        };
        # non-ascii 088
        Keypad6 = {
          ascii = 65535;
          code = 88;
        };
        # non-ascii 089
        Keypad7 = {
          ascii = 65535;
          code = 89;
        };
        # non-ascii 090
        F20 = {
          ascii = 65535;
          code = 90;
        };
        # non-ascii 091
        Keypad8 = {
          ascii = 65535;
          code = 91;
        };
        # non-ascii 092
        Keypad9 = {
          ascii = 65535;
          code = 92;
        };
        # non-ascii 096
        F5 = {
          ascii = 65535;
          code = 96;
        };
        # non-ascii 097
        F6 = {
          ascii = 65535;
          code = 97;
        };
        # non-ascii 098
        F7 = {
          ascii = 65535;
          code = 98;
        };
        # non-ascii 099
        F3 = {
          ascii = 65535;
          code = 99;
        };
        # non-ascii 100
        F8 = {
          ascii = 65535;
          code = 100;
        };
        # non-ascii 101
        F9 = {
          ascii = 65535;
          code = 101;
        };
        # non-ascii 103
        F11 = {
          ascii = 65535;
          code = 103;
        };
        # non-ascii 105
        F13 = {
          ascii = 65535;
          code = 105;
        };
        # non-ascii 106
        F16 = {
          ascii = 65535;
          code = 106;
        };
        # non-ascii 107
        F14 = {
          ascii = 65535;
          code = 107;
        };
        # non-ascii 109
        F10 = {
          ascii = 65535;
          code = 109;
        };
        # non-ascii 111
        F12 = {
          ascii = 65535;
          code = 111;
        };
        # non-ascii 113
        F15 = {
          ascii = 65535;
          code = 113;
        };
        # non-ascii 114
        Help = {
          ascii = 65535;
          code = 114;
        };
        # non-ascii 115
        Home = {
          ascii = 65535;
          code = 115;
        };
        # non-ascii 116
        PageUp = {
          ascii = 65535;
          code = 116;
        };
        # non-ascii 117
        ForwardDelete = {
          ascii = 65535;
          code = 117;
        };
        # non-ascii 118
        F4 = {
          ascii = 65535;
          code = 118;
        };
        # non-ascii 119
        End = {
          ascii = 65535;
          code = 119;
        };
        # non-ascii 120
        F2 = {
          ascii = 65535;
          code = 120;
        };
        # non-ascii 121
        PageDown = {
          ascii = 65535;
          code = 121;
        };
        # non-ascii 122
        F1 = {
          ascii = 65535;
          code = 122;
        };
        # non-ascii 123
        LeftArrow = {
          ascii = 65535;
          code = 123;
        };
        # non-ascii 124
        RightArrow = {
          ascii = 65535;
          code = 124;
        };
        # non-ascii 125
        DownArrow = {
          ascii = 65535;
          code = 125;
        };
        # non-ascii 126
        UpArrow = {
          ascii = 65535;
          code = 126;
        };
      };

      # modifiers: https://gist.github.com/stephancasas/74c4621e2492fb875f0f42778d432973
      # also https://github.com/phracker/MacOSX-SDKs/blob/master/MacOSX10.6.sdk/System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/HIToolbox.framework/Versions/A/Headers/Events.h
      #        0 | 0x000000 => None
      #    65536 | 0x010000 => AlphaShift (NX_ALPHASHIFTMASK)
      #   131072 | 0x020000 => Shift (NX_SHIFTMASK)
      #   262144 | 0x040000 => Control (NX_CONTROLMASK)
      #   524288 | 0x080000 => Option (NX_ALTERNATEMASK)
      #  1048576 | 0x100000 => Command (NX_COMMANDMASK)
      #  2097152 | 0x200000 => NumPad (NX_NUMERICPADMASK)
      #  4194304 | 0x400000 => Help (NX_HELPMASK)
      #  8388608 | 0x800000 => Fn (NX_SECONDARYFNMASK)
      #
      # In dec/hex:
      #        0 | 0x000000 => ModNone
      # xxxxxxxx | 0x010000 => ModAlphaShift
      #   131072 | 0x020000 => ModShift
      #   262144 | 0x040000 => ModControl
      #   393216 | 0x060000 => ModShift + ModControl
      #   524288 | 0x080000 => ModOption
      #   655360 | 0x0A0000 => ModShift + ModOption
      #   786432 | 0x0C0000 => ModControl + ModOption
      #   917504 | 0x0E0000 => ModShift + ModControl + ModOption
      #  1048576 | 0x100000 => ModCommand
      #  1179648 | 0x120000 => ModShift + ModCommand
      #  1310720 | 0x140000 => ModControl + ModCommand
      #  1441792 | 0x160000 => ModShift + ModControl + ModCommand
      #  1572864 | 0x180000 => ModOption + ModCommand
      #  1703936 | 0x1A0000 => ModShift + ModOption + ModCommand
      #  1835008 | 0x1C0000 => ModControl + ModOption + ModCommand
      #  1966080 | 0x1E0000 => ModShift + ModControl + ModOption + ModCommand
      # xxxxxxxx | 0x200000 => ModNumPad
      # xxxxxxxx | 0x400000 => ModHelp
      #  8388608 | 0x800000 => ModFn
      #  8519680 | 0x820000 => ModFn + ModShift
      #  8650752 | 0x840000 => ModFn + ModControl
      #  8781824 | 0x860000 => ModFn + ModShift + ModControl
      #  8912896 | 0x880000 => ModFn + ModOption
      #  9043968 | 0x8A0000 => ModFn + ModShift + ModOption
      #  9175040 | 0x8C0000 => ModFn + ModControl + ModOption
      #  9306112 | 0x8E0000 => ModFn + ModShift + ModControl + ModOption
      #  9437184 | 0x900000 => ModFn + ModCommand
      #  9568256 | 0x920000 => ModFn + ModShift + ModCommand
      #  9699328 | 0x940000 => ModFn + ModControl + ModCommand
      #  9830400 | 0x960000 => ModFn + ModShift + ModControl + ModCommand
      #  9961472 | 0x980000 => ModFn + ModOption + ModCommand
      # 10092544 | 0x9A0000 => ModFn + ModShift + ModOption + ModCommand
      # 10223616 | 0x9C0000 => ModFn + ModControl + ModOption + ModCommand
      # 10354688 | 0x9E0000 => ModFn + ModShift + ModControl + ModOption + ModCommand
      modifiers = {
        None = 0;
        AlphaShift = 65536;
        Shift = 131072;
        Control = 262144;
        Option = 524288;
        Command = 1048576;
        NumPad = 2097152;
        Help = 4194304;
        Fn = 8388608;
      };
    };

    # config.system.defaults.CustomUserPreferences."com.apple.symbolichotkeys".AppleSymbolicHotKeys = config.system.hotkeys;
    system.activationScripts = {
      extraActivation.text = lib.mkAfter config.system.activationScripts.hotkeys.text;
      hotkeys.text = ''
        echo >&2 "configuring system hotkeys..."
        ${lib.concatStringsSep "" (
          hotkeysToScript (lib.deepSeq config.system.hotkeys config.system.hotkeys)
        )}
        # No-op that updates a system in-memory cache. Needed for reload to work.
        defaults read com.apple.symbolichotkeys.plist > /dev/null
      '';
    };
  };
}
