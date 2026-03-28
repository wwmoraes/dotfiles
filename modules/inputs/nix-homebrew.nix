{
  inputs,
  lib,
  ...
}:
{
  flake-file.inputs.nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  # flake-file.inputs.homebrew-cask = {
  #   url = "github:homebrew/homebrew-cask";
  #   flake = false;
  # };
  # flake-file.inputs.homebrew-core = {
  #   url = "github:homebrew/homebrew-core";
  #   flake = false;
  # };

  flake.modules.darwin.default =
    {
      config,
      ...
    }:
    {
      imports = [
        inputs.nix-homebrew.darwinModules.nix-homebrew
      ];

      environment.infoPath = [
        (toString (/. + "${config.homebrew.brewPrefix or ""}/../share/info"))
      ];

      environment.manPath = [
        (toString (/. + "${config.homebrew.brewPrefix}/../share/man"))
      ];

      environment.systemPath = lib.mkOrder 1100 [
        config.homebrew.brewPrefix
        (toString (/. + "${config.homebrew.brewPrefix}/../sbin"))
      ];

      environment.variables =
        let
          isSetString = str: lib.stringLength (toString str) > 0;
        in
        {
          HOMEBREW_CASK_OPTS = lib.concatStringsSep " " (
            builtins.filter (v: v != "") [
              (lib.optionalString (isSetString config.homebrew.caskArgs.appdir) "--appdir=${config.homebrew.caskArgs.appdir}")
              "--keyboard-layoutdir=${lib.escapeShellArg "~/Library/Keyboard Layouts"}"
              (lib.optionalString config.homebrew.caskArgs.no_quarantine "--no-quarantine")
            ]
          );
          HOMEBREW_NO_ANALYTICS = "1";
          HOMEBREW_NO_AUTO_UPDATE = "1";
          HOMEBREW_NO_ENV_HINTS = "1";
          HOMEBREW_NO_INSTALL_CLEANUP = "1";
          HOMEBREW_NO_INSTALL_UPGRADE = "1";
          HOMEBREW_NO_UPDATE_REPORT_NEW = "1";
          # xdg.systemDirs does NOT support darwin for whatever reason...
          XDG_DATA_DIRS = lib.mkAfter [
            (toString (/. + "${config.homebrew.brewPrefix}/../share"))
          ];
        };

      homebrew = {
        enable = true;

        brews =
          let
            hasApps = (builtins.length (builtins.attrNames config.homebrew.masApps)) > 0;
            hasTaps = (builtins.length config.homebrew.taps) > 0;
          in
          lib.mkMerge [
            (lib.optional hasApps "mas") # # used internally by brew masApps
            (lib.optional hasTaps "gh") # # used internally by brew taps
          ];

        caskArgs = {
          appdir = "~/Applications";
          # keyboard_layoutdir = "~/Library/Keyboard Layouts";
          no_quarantine = true;
        };

        global = {
          autoUpdate = true;
          brewfile = true;
          lockfiles = false;
        };

        onActivation = {
          autoUpdate = false;
          upgrade = false;
          cleanup = "uninstall";
        };

        taps = [
          "homebrew/bundle"
          "homebrew/services"
          "wwmoraes/tap"
        ];
      };

      nix-homebrew = {
        autoMigrate = true;
        enable = true;
        enableFishIntegration = false;
        enableRosetta = false;
        group = "staff";
        # mutableTaps = false;
        # taps = {
        #   "homebrew/homebrew-core" = homebrew-core;
        #   "homebrew/homebrew-cask" = homebrew-cask;
        # };
        user = config.system.primaryUser;
      };

      ## TODO fix upstream https://github.com/zhaofengli/nix-homebrew/blob/5108f0846cde2080aaeb1c7b08e3bd7d27f33b57/modules/default.nix#L503-L505
      programs.fish.interactiveShellInit = ''
        brew shellenv fish 2>/dev/null | source || true
      '';

      system.defaults.CustomSystemPreferences."/Library/Preferences/com.apple.TimeMachine".SkipPaths = [
        (toString (/. + "${config.homebrew.brewPrefix}/.."))
      ];
    };
}
