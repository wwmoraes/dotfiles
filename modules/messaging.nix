{
  nixpkgs.config.allowUnfreePackages = [
    # keep-sorted start
    "slack"
    # keep-sorted end
  ];

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
