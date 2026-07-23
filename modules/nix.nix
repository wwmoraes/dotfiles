{
  lib,
  ...
}:
{
  flake-file.nixConfig = {
    builders = "ssh-ng://root@vidar aarch64-linux - - - big-parallel,kvm; ssh-ng://root@nas x86_64-linux - - - big-parallel,kvm";
    builders-use-substitutes = true;
    substituters = [
      "https://cache.nixos.org/"
      "https://nix-community.cachix.org/"
    ];
    extra-experimental-features = [
      "pipe-operators"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    warn-dirty = false;
  };

  flake.modules.generic.default =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = [
        # keep-sorted start
        pkgs.git
        pkgs.nix-index
        pkgs.nix-init
        pkgs.nixos-rebuild
        pkgs.nurl
        # keep-sorted end
      ];

      home-manager.sharedModules = [
        {
          programs.helix.extraPackages = lib.mkMerge [
            [
              pkgs.unstable.nil
              pkgs.unstable.nixd
            ]
          ];
        }
      ];

      nix = {
        package = pkgs.nixVersions.latest;
        settings = {
          accept-flake-config = true;
          allowed-users = [
            "root"
            "@root"
            "@wheel"
          ];
          extra-experimental-features = [
            "flakes"
            "nix-command"
            "pipe-operators"
          ];
          require-sigs = true;
          sandbox = true;
          sandbox-fallback = false;
          substituters = [
            "https://wwmoraes.cachix.org/"
            "https://nix-community.cachix.org/"
            "https://cache.nixos.org/"
          ];
          trusted-public-keys = [
            "wwmoraes.cachix.org-1:N38Kgu19R66Jr62aX5rS466waVzT5p/Paq1g6uFFVyM="
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          ];
          trusted-users = [
            "@root"
            "@wheel"
          ];
          warn-dirty = false;
        };
      };
    };

  flake.modules.darwin.default = {
    nix.settings = {
      allowed-users = [ "@admin" ];
      trusted-users = [ "@admin" ];
    };
  };

  flake.modules.darwin.single-user'personal = {
    nix.settings.builders = lib.mkForce "ssh-ng://root@vidar aarch64-linux - - - big-parallel,kvm; ssh-ng://root@nas x86_64-linux - - - big-parallel,kvm";
  };

  flake.modules.darwin.multi-user =
    {
      ...
    }:
    {
      ids.gids.nixbld = 350;
      nix.distributedBuilds = true;
      nix.enable = true;
    };

  flake.modules.darwin.multi-user'personal = {
    nix.buildMachines = [
      {
        hostName = "vidar";
        protocol = "ssh-ng";
        sshUser = "root";
        supportedFeatures = [
          "big-parallel"
          "kvm"
        ];
        system = "aarch64-linux";
      }
      {
        hostName = "nas";
        protocol = "ssh-ng";
        sshUser = "root";
        supportedFeatures = [
          "big-parallel"
          "kvm"
        ];
        system = "x86_64-linux";
      }
    ];
  };

  flake.modules.darwin.personal =
    {
      ...
    }:
    {
      nix.settings = {
        builders-use-substitutes = true;
      };

      system.defaults.timemachine = {
        SkipPaths = [
          /nix
        ];

        perUser.home.SkipPaths = [
          ".nix-defexpr"
          ".nix-profile"
        ];
      };
    };
}
