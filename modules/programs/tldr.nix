{
  flake.modules.homeManager.shell =
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
}
