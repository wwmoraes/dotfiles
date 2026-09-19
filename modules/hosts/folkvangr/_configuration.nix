{
  lib,
  ...
}:
{
  imports = [
    # keep-sorted start
    ./_disko.nix
    ./_hardware-configuration.nix
    # keep-sorted end
  ];

  # boot.extraModulePackages = with config.boot.kernelPackages; [
  #   r8127
  # ];

  boot.kernel.sysctl = {
    "vm.swappiness" = 20; # less swapping
  };

  boot.loader = {
    grub.enable = false;
    systemd-boot.enable = true;
  };

  boot.kernelParams = [
    "console=ttyAMA0,115200n8"
    "console=tty0"
  ];

  fileSystems = {
    "/".neededForBoot = true;
    "/etc".neededForBoot = true;
    "/home".neededForBoot = true;
    "/nix".neededForBoot = true;
    "/root".neededForBoot = true;
    "/srv".neededForBoot = true;
    "/var/lib".neededForBoot = true;
    "/var/log".neededForBoot = true;
  };

  networking = {
    hostName = "folkvangr";
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
    wireless.iwd = {
      settings = {
        General.Country = "NL";
      };
    };
  };

  nixpkgs.hostPlatform = "aarch64-linux";

  programs.fish.enable = true;

  services = {
    btrfs.autoScrub.enable = true;
    fstrim.enable = true;
    openssh = {
      enable = true;
      settings = {
        MaxSessions = 20;
        MaxStartups = "10:20:50";
        StreamLocalBindUnlink = true;
      };
    };
  };

  swapDevices = [
    {
      device = "/run/swap/default";
      size = 64 * 1024;
      randomEncryption = {
        enable = true;
        allowDiscards = true;
      };
    }
  ];

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

  system.stateVersion = "25.11";
}
