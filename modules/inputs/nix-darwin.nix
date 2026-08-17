{ lib, ... }:
{
  flake-file.inputs.nix-darwin = {
    inputs.nixpkgs.follows = "nixpkgs";
    url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
  };

  # add support for user-level defined brew components
  flake.modules.darwin.default = { config, options, ... }: {
    home-manager.sharedModules = [
      {
        options.homebrew = {
          inherit (options.homebrew)
            brews
            casks
            masApps
            prefix
            ;
        };
      }
    ];

    homebrew.brews =
      config.home-manager.users
      |> builtins.attrValues
      |> map (attrs: attrs.homebrew.brews)
      |> builtins.concatLists;

    homebrew.casks =
      config.home-manager.users
      |> builtins.attrValues
      |> map (attrs: attrs.homebrew.casks)
      |> builtins.concatLists;

    homebrew.masApps =
      config.home-manager.users
      |> builtins.attrValues
      |> map (attrs: attrs.homebrew.masApps)
      |> lib.mergeAttrsList;
  };

  flake.modules.nixos.default =
    { config, ... }:
    let
      cfg = config.homebrew;
    in
    {
      options.homebrew = with lib.types; {
        brews = lib.mkOption {
          type = listOf anything;
        };
        casks = lib.mkOption {
          type = listOf anything;
        };
        masApps = lib.mkOption {
          type = attrsOf ints.positive;
        };
        prefix = lib.mkOption {
          type = str;
          default = "/usr/local";
        };
      };

      config = {
        warnings = builtins.concatLists [
          (lib.optional (
            builtins.length cfg.brews > 0
          ) "Homebrew brews aren't supported on NixOS yet. Install those packages using other means.")
          (lib.optional (
            builtins.length cfg.casks > 0
          ) "Homebrew casks aren't supported on NixOS yet. Install those packages using other means.")
          (lib.optional (
            builtins.length (builtins.attrNames cfg.masApps) > 0
          ) "Homebrew MAS apps are exclusive to Darwin. Install applications using other means on NixOS.")
        ];
      };
    };
}
