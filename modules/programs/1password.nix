{
  lib,
  ...
}:
{
  nixpkgs.config.allowUnfreePackages = [
    "1password"
    "1password-cli"
  ];

  flake.modules.generic.default =
    {
      config,
      ...
    }:
    let
      shellAliases = lib.genAttrs [
        "brew"
        "cachix"
        "gh"
      ] (name: "op plugin run -- " + name);
    in
    {
      environment.shellAliases = shellAliases;

      home-manager.sharedModules = lib.optional config.programs._1password.enable {
        home.shellAliases = shellAliases;
      };
    };

  flake.modules.darwin.default =
    {
      config,
      ...
    }:
    {
      homebrew.masApps = lib.optionalAttrs config.programs._1password-gui.enable {
        "1Password for Safari" = 1569813296;
      };
    };
}
