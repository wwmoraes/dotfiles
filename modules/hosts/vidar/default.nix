{
  lib,
  ...
}:
{
  configurations.nixos.vidar = {
    contexts = [
      # keep-sorted start
      "personal"
      # keep-sorted end
    ];

    profiles = [
      # keep-sorted start
      "default"
      "gpg"
      "shell"
      # keep-sorted end
    ];

    users = {
      root = [ ];
      william = [ ];
    };

    module = {
      imports = [
        ./_hardware-configuration.nix
      ];

      boot = {
        kernelParams = [
          "console=ttyS1,115200n8"
        ];
        loader = {
          # Enables the generation of /boot/extlinux/extlinux.conf
          generic-extlinux-compatible.enable = true;
          # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
          grub.enable = false;
          systemd-boot.enable = false;
        };
      };

      fileSystems = {
        "/" = {
          device = lib.mkForce "/dev/disk/by-label/NIXOS_SD";
          fsType = "ext4";
        };
        "/boot/firmware" = {
          device = "/dev/disk/by-label/FIRMWARE";
          fsType = "vfat";
        };
      };

      networking = {
        domain = "home.arpa";
        hostName = "vidar";
        networkmanager.enable = true;
      };

      nixpkgs.hostPlatform = "aarch64-linux";

      programs = {
        dconf.enable = true; # needed by home-manager somehow
        fish.enable = true;
      };

      services.openssh = {
        enable = true;
        settings = {
          MaxSessions = 20;
          MaxStartups = "10:20:50";
          StreamLocalBindUnlink = true;
        };
        # extraConfig = ''
        #   StreamLocalBindUnlink yes
        #   MaxSessions 20
        #   MaxStartups 10:20:50
        # '';
      };

      users.mutableUsers = false;

      virtualisation.vmVariant = {
        boot.loader = {
          generic-extlinux-compatible.enable = lib.mkForce false;
          systemd-boot.enable = lib.mkForce true;
        };
      };

      zramSwap = {
        enable = true;
        memoryPercent = 100;
      };
    };
  };

  flake.modules.homeManager.personal =
    {
      config,
      ...
    }:
    {
      programs.ssh.matchBlocks."vidar vidar.home.arpa" = {
        extraOptions = {
          HostKeyAlgorithms = "+ssh-rsa";
          PubkeyAcceptedKeyTypes = "+ssh-rsa";
        };
        remoteForwards = [
          {
            bind.address = "/run/user/1001/gnupg/S.gpg-agent";
            host.address = "${config.programs.gpg.homedir}/S.gpg-agent.extra";
          }
          {
            # bind.address = "/root/.gnupg/S.gpg-agent";
            bind.address = "/run/user/0/gnupg/S.gpg-agent";
            host.address = "${config.programs.gpg.homedir}/S.gpg-agent.extra";
          }
        ];
      };
    };
}
