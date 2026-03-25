{
  flake.modules.darwin.default =
    {
      config,
      ...
    }:
    {
      system.defaults.CustomSystemPreferences."/Library/Preferences/com.apple.TimeMachine".SkipPaths = [
        /Applications
        /private
      ]
      ++ (
        config.users.users
        |> builtins.attrValues
        |> builtins.concatMap (user: [
          "${user.home}/.Trash"
          "${user.home}/.cache"
          "${user.home}/.local"
          "${user.home}/Applications"
          "${user.home}/Desktop"
          "${user.home}/Downloads"
          "${user.home}/Library/Caches"
          "${user.home}/Library/CloudStorage"
          "${user.home}/Library/Containers"
          "${user.home}/Library/Daemon Containers"
          "${user.home}/Library/Developer"
          "${user.home}/Library/Group Containers"
          "${user.home}/Library/HTTPStorages"
          "${user.home}/Library/IntelligencePlatform"
          "${user.home}/Library/Logs"
          "${user.home}/Library/Mail"
          "${user.home}/Library/Messages"
          "${user.home}/Library/Metadata"
          "${user.home}/Library/Mobile Documents"
          "${user.home}/Library/Safari"
        ])
      );
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
