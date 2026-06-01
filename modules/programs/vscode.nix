{
  nixpkgs.config.allowUnfreePackages = [
    "vscode"
  ];

  flake.modules.homeManager.work'disabled =
    {
      pkgs,
      ...
    }:
    {
      home.packages = [
        pkgs.vscode
      ];
    };
}
