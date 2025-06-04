{
  xdg = {
    enable = true;
    systemDirs = {
      ## TODO sort out recursion
      # config = [
      #   "${config.home.homeDirectory}/.nix-profile/etc/xdg"
      #   "/etc/profiles/per-user/${config.home.username}/etc/xdg"
      #   # "/run/current-system/sw/etc/xdg"
      #   # "/nix/var/nix/profiles/default/etc/xdg"
      # ] ++ config.darwinConfig.environment.variables.XDG_CONFIG_DIRS;
      # data = [
      #   "${config.home.homeDirectory}/.nix-profile/share"
      #   "/etc/profiles/per-user/${config.home.username}/share"
      #   # "/run/current-system/sw/share"
      #   # "/nix/var/nix/profiles/default/share"
      #   # "/opt/homebrew/share"
      #   # "/usr/local/share"
      #   # "/usr/share"
      # ] ++ config.darwinConfig.environment.variables.XDG_DATA_DIRS;
    };
  };
}
