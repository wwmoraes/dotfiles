{
  flake.modules.homeManager.personal = { config, pkgs, ... }: {
    home.packages = [
      config.services.tldr-update.package
    ];

    services.tldr-update.package = pkgs.tlrc;
  };

  flake.modules.darwin.personal = {
    system.defaults.timemachine.perUser.home.SkipPaths = [
      ".tldrc"
    ];
  };
}
