{
  flake.modules.homeManager.shell'personal =
    {
      config,
      pkgs,
      ...
    }:
    {
      home.packages = [
        config.services.tldr-update.package
      ];

      services.tldr-update = {
        enable = true;
        package = pkgs.tlrc;
      };
    };

  flake.modules.darwin.shell'personal = {
    system.defaults.timemachine.perUser.home.SkipPaths = [
      ".tldrc"
    ];
  };
}
