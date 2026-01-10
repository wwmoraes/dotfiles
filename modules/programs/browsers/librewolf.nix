{
  flake.modules.homeManager.gui = {
    programs.librewolf = {
      enable = true;
      profiles.default = { };
      settings = {
        "privacy.clearOnShutdown.cookies" = false;
        "privacy.clearOnShutdown.history" = false;
      };
    };

    stylix.targets.librewolf.profileNames = [ "default" ];
  };
}
