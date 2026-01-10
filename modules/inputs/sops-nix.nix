{
  inputs,
  self,
  ...
}:
{
  flake-file.inputs.sops-nix = {
    inputs.nixpkgs.follows = "nixpkgs";
    url = "github:Mic92/sops-nix";
  };

  flake.modules.generic.default = {
    home-manager.sharedModules = [
      inputs.sops-nix.homeManagerModules.sops
    ];

    # TODO https://github.com/Mic92/sops-nix?tab=readme-ov-file#qubes-split-gpg-support
    sops = {
      age = {
        sshKeyPaths = [ ];
        generateKey = false;
      };
      defaultSopsFile = self + /secrets.yaml;
      gnupg = {
        sshKeyPaths = [ ];
      };
    };
  };

  flake.modules.generic.william =
    {
      config,
      ...
    }:
    {
      # TODO this should point to the primary user; nixos doesn't have a prop for that
      sops.gnupg.home = config.home-manager.users.william.programs.gpg.homedir;
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
    };
}
