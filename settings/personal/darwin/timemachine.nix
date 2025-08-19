{
  system.defaults = {
    CustomUserPreferences = {
      # "com.apple.TimeMachine" = {
      #   DoNotOfferNewDisksForBackup = true;
      # };
      "com.apple.systemuiserver" = {
        "NSStatusItem Visible com.apple.menuextra.TimeMachine" = true;
        menuExtras = [
          "/System/Library/CoreServices/Menu Extras/TimeMachine.menu"
        ];
      };
    };
    CustomSystemPreferences = {
      # "/Library/Preferences/com.apple.TimeMachine" = {
      #   AutoBackup = true;
      #   AutoBackupInterval = 86400;
      #   ExcludeByPath = [];
      #   # MobileBackups = false;
      #   RequiresACPower = true;
      #   SkipPaths = [
      #     "~/.cabal"
      #     "~/.cache"
      #     "~/.cargo"
      #     "~/.go"
      #     "~/.gradle"
      #     "~/.local/share/containers"
      #     "~/.minikube"
      #     "~/.npm"
      #     "~/.pulumi/plugins"
      #     "~/.rustup"
      #     "~/.sonarlint"
      #     "~/Applications"
      #     "~/Cloud"
      #     "~/Desktop"
      #     "~/Downloads"
      #     "~/Library/Caches"
      #     "~/Library/CloudStorage"
      #     "~/Library/Containers"
      #     "~/Library/Developer"
      #     "~/Library/Group Containers"
      #     "~/Zotero"
      #     "~/dev"
      #     "~/go"
      #   ];
      # };
    };
  };
}
