{
  lib,
  ...
}:
{
  configurations.nixos.folkvangr = {
    contexts = [
      # keep-sorted start
      "personal"
      # keep-sorted end
    ];

    profiles = [
      # keep-sorted start
      "default"
      "gpg"
      "hardening"
      "media-server"
      "nas"
      "shell"
      # keep-sorted end
    ];

    users = {
      root = [ ];
      william = [ ];
    };

    module = {
      imports = [
        # keep-sorted start
        # keep-sorted end
      ];

      boot.loader = {
        efi.canTouchEfiVariables = true;
        grub.enable = false;
        systemd-boot.enable = true;
      };

      fileSystems = {
        "/" = {
          device = "/dev/disk/by-label/nixos";
          fsType = "ext4";
        };

        "/boot" = {
          device = "/dev/disk/by-label/ESP";
          fsType = "vfat";
        };
      };

      networking = {
        domain = "home.arpa";
        hostName = "folkvangr";
        networkmanager.enable = true;
        useDHCP = lib.mkDefault true;
      };

      nixpkgs.hostPlatform = "x86_64-linux";

      programs.fish.enable = true;

      services.openssh = {
        enable = true;
        settings = {
          AcceptEnv = "ZELLIJ";
          MaxSessions = 20;
          MaxStartups = "10:20:50";
          StreamLocalBindUnlink = true;
        };
      };

      users.mutableUsers = false;

      virtualisation = {
        libvirtd = {
          enable = true;
          qemu = {
            swtpm.enable = true;
          };
        };
        vmVariant = {
          virtualisation = {
            cores = 4;
            graphics = false;
            memorySize = 2048;
          };
        };
      };
    };
  };
}
