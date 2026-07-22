{
  flake.modules.darwin.default =
    {
      ...
    }:
    {
      system.defaults.timemachine = {
        perUser.home.SkipPaths = [
          ".Trash"
          ".cache"
          ".local"
          "Applications"
          "Desktop"
          "Downloads"
          "Library/Caches"
          "Library/CloudStorage"
          "Library/Containers"
          "Library/Daemon Containers"
          "Library/Developer"
          "Library/Group Containers"
          "Library/HTTPStorages"
          "Library/IntelligencePlatform"
          "Library/Logs"
          "Library/Mail"
          "Library/Messages"
          "Library/Metadata"
          "Library/Mobile Documents"
          "Library/Safari"
        ];

        SkipPaths = [
          /Applications
          /private
        ];
      };
    };

  flake.modules.darwin.personal = {
    /*
      TODO extra settings to turn into declarative options
      # echo "setting: Disable local Time Machine backups"
      # hash tmutil > /dev/null 2>&1 && sudo tmutil disablelocal

      echo "setting: thin local Time Machine snapshots"
      hash tmutil > /dev/null 2>&1 && sudo tmutil thinlocalsnapshots / 1000000000 1 > /dev/null 2>&1
    */
    system.defaults = {
      CustomUserPreferences = {
        "com.apple.TimeMachine" = {
          DoNotOfferNewDisksForBackup = true;
        };
        "com.apple.systemuiserver" = {
          "NSStatusItem Visible com.apple.menuextra.TimeMachine" = true;
          menuExtras = [
            "/System/Library/CoreServices/Menu Extras/TimeMachine.menu"
          ];
        };
      };
      CustomSystemPreferences = {
        "/Library/Preferences/com.apple.TimeMachine" = {
          AutoBackup = true;
          AutoBackupInterval = 86400;
          ExcludeByPath = [ ];
          MobileBackups = false;
          RequiresACPower = true;
          SkipPaths = [
            # keep-sorted start
            # "${config.system.primaryUserHome}/.fly"
            # "${config.system.primaryUserHome}/.imapfilter"
            # "${config.system.primaryUserHome}/.pulumi/plugins"
            # keep-sorted end
          ];
        };
      };
    };
  };
}
