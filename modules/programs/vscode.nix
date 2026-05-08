{
  nixpkgs.config.allowUnfreePackages = [
    "vscode"
  ];

  flake.modules.homeManager.work =
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
