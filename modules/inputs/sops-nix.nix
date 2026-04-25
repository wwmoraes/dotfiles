{
  inputs,
  self,
  lib,
  ...
}:
let
  commonSopsSettings = {
    age = {
      sshKeyPaths = [ ];
      generateKey = false;
    };
    gnupg = {
      sshKeyPaths = [ ];
    };
  };
in
{
  flake-file.inputs.sops-nix = {
    inputs.nixpkgs.follows = "nixpkgs";
    url = "github:Mic92/sops-nix";
  };

  flake.modules.generic.default = {
    home-manager.sharedModules = [
      inputs.sops-nix.homeManagerModules.sops
      (
        { config, name, ... }:
        {
          sops = commonSopsSettings // {
            defaultSopsFile = self + /modules/users/${name}/secrets.yaml;
            gnupg.home = config.programs.gpg.homedir;
          };
        }
      )
    ];

    # TODO https://github.com/Mic92/sops-nix?tab=readme-ov-file#qubes-split-gpg-support
    sops = commonSopsSettings // {
      defaultSopsFile = self + /secrets.yaml;
    };
  };

  flake.modules.nixos.default = {
    imports = [
      inputs.sops-nix.nixosModules.sops
    ];
  };

  flake.modules.darwin.default =
    {
      config,
      ...
    }:
    {
      imports = [
        inputs.sops-nix.darwinModules.sops
      ];

      sops = {
        gnupg = {
          home = config.home-manager.users.${config.system.primaryUser}.programs.gpg.homedir;
        };
      };

      home-manager.sharedModules = [
        {
          launchd.agents.sops-nix.config.KeepAlive = lib.mkForce {
            SuccessfulExit = false;
            Crashed = true;
          };
        }
      ];
    };
}
