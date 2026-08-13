{
  flake.modules.darwin.gui'personal = {
    system.defaults.timemachine.perUser.home.SkipPaths = [
      ".librewolf"
    ];
  };

  flake.modules.homeManager.gui'disabled = {
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
