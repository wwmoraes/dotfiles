{
  flake.modules.darwin.default = {
    system.defaults = {
      CustomUserPreferences = {
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
    };
  };
}
