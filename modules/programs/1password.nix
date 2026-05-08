{
  nixpkgs.config.allowUnfreePackages = [
    "1password-cli"
  ];

  flake.modules.darwin.personal =
    {
      pkgs,
      ...
    }:
    {
      homebrew.casks = [
        (pkgs.lib.local.globalCask "1password")
      ];

      homebrew.masApps = {
        "1Password for Safari" = 1569813296;
      };
    };

  flake.modules.homeManager.personal =
    {
      pkgs,
      ...
    }:
    {
      home.packages = [
        pkgs._1password-cli
      ];

      programs.fish.shellAliases = {
        brew = "op plugin run -- brew";
        cachix = "op plugin run -- cachix";
        doctl = "op plugin run -- doctl";
        gh = "op plugin run -- gh";
        pulumi = "op plugin run -- pulumi";
      };
    };
}
