{
  config,
  inputs,
  ...
}:
{
  flake-file.inputs.home-manager = {
    inputs.nixpkgs.follows = "nixpkgs";
    url = "github:nix-community/home-manager/release-25.11";
  };

  imports = [
    inputs.home-manager.flakeModules.home-manager
  ];

  flake.modules.generic.default = {
    home-manager = {
      backupFileExtension = "bkp";
      sharedModules = [
        {
          home.enableNixpkgsReleaseCheck = true;
          home.stateVersion = "25.05";
        }
      ];
      useGlobalPkgs = true;
      useUserPackages = true;
    };
  };

  flake.modules.nixos.default = {
    imports = [
      inputs.home-manager.nixosModules.home-manager
    ];
  };

  flake.modules.darwin.default =
    {
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.home-manager.darwinModules.home-manager
      ];

      environment.systemPackages = [
        config.flake.packages.${pkgs.stdenv.hostPlatform.system}.switch-home
      ];

      home-manager.sharedModules = [
        {
          # copy apps instead as Spotlight does NOT work with symlinks :(
          targets.darwin.copyApps.enable = true;
          targets.darwin.linkApps.enable = false;
        }
      ];
    };
}
