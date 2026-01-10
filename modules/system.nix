{
  flake.modules.darwin.default = {
    /*
      TODO extra settings to turn into declarative options
      echo "Spotlight: Load new settings before rebuilding the index"
      killall mds > /dev/null || true

      echo "Spotlight: enable indexing for the main volume"
      sudo mdutil -i on / > /dev/null

      # echo "Spotlight: Rebuild the index from scratch"
      # sudo mdutil -E / > /dev/null

      echo "Finder: always show the user Library folder"
      chflags nohidden "${HOME}/Library"

      echo "Finder: Show the /Volumes folder"
      sudo chflags nohidden /Volumes

      # echo "setting: Disable Notification Center and remove the menu bar icon"
      # launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist 2> /dev/null

      # echo "setting: Stop iTunes from responding to the keyboard media keys"
      # launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2> /dev/null

      ## disable system integrity protection on fs, nvram and debug
      # csrutil enable --without fs --without nvram --without debug
    */

    system.activationScripts.postActivation.text = ''
      printf >&2 "cleaning up root mail...\n"
      echo 'd *' | mailx > /dev/null 2>&1 || true

      printf >&2 "reloading quicklook plugins...\n"
      qlmanage -r
    '';

    system.nvram.variables = {
      # SystemAudioVolume = "%01";
      StartupMute = "%01";
    };
  };
}
