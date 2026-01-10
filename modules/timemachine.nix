{
  flake.modules.darwin.personal =
    {
      config,
      ...
    }:
    {
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
              "${config.system.primaryUserHome}/.Trash"
              "${config.system.primaryUserHome}/.aider"
              "${config.system.primaryUserHome}/.cabal"
              "${config.system.primaryUserHome}/.cache"
              "${config.system.primaryUserHome}/.cargo"
              "${config.system.primaryUserHome}/.cfagent"
              "${config.system.primaryUserHome}/.dlv"
              "${config.system.primaryUserHome}/.docker"
              "${config.system.primaryUserHome}/.fly"
              "${config.system.primaryUserHome}/.go"
              "${config.system.primaryUserHome}/.gradle"
              "${config.system.primaryUserHome}/.hammerspoon"
              "${config.system.primaryUserHome}/.imapfilter"
              "${config.system.primaryUserHome}/.kube"
              "${config.system.primaryUserHome}/.lima"
              "${config.system.primaryUserHome}/.local"
              "${config.system.primaryUserHome}/.logseq"
              "${config.system.primaryUserHome}/.minikube"
              "${config.system.primaryUserHome}/.moby"
              "${config.system.primaryUserHome}/.nix-defexpr"
              "${config.system.primaryUserHome}/.nix-profile"
              "${config.system.primaryUserHome}/.npm"
              "${config.system.primaryUserHome}/.ollama"
              "${config.system.primaryUserHome}/.plandex-home"
              "${config.system.primaryUserHome}/.pulumi/plugins"
              "${config.system.primaryUserHome}/.quio"
              "${config.system.primaryUserHome}/.rustup"
              "${config.system.primaryUserHome}/.sonarlint"
              "${config.system.primaryUserHome}/.stack"
              "${config.system.primaryUserHome}/.tldrc"
              "${config.system.primaryUserHome}/Applications"
              "${config.system.primaryUserHome}/Cloud"
              "${config.system.primaryUserHome}/Desktop"
              "${config.system.primaryUserHome}/Downloads"
              "${config.system.primaryUserHome}/Library/Caches"
              "${config.system.primaryUserHome}/Library/CloudStorage"
              "${config.system.primaryUserHome}/Library/Containers"
              "${config.system.primaryUserHome}/Library/Developer"
              "${config.system.primaryUserHome}/Library/Group Containers"
              "${config.system.primaryUserHome}/Zotero"
              "${config.system.primaryUserHome}/dev"
              "${config.system.primaryUserHome}/go"
              /Applications
              /nix
              /opt/homebrew
              /private
              # keep-sorted end
            ];
          };
        };
      };
    };
}
