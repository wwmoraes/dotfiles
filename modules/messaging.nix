{
  flake.modules.homeManager.messaging'personal =
    {
      pkgs,
      ...
    }:
    {
      home.packages = [
        pkgs.slack
      ];
    };
}
