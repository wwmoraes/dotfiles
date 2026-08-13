{
  lib,
  ...
}:
{
  imports = [
    ./_hardware-configuration.nix
  ];

  boot = {
    kernelParams = [
      "console=ttyS1,115200n8"
      "console=tty0"
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
      options = [ "noatime" ];
    };
    "/boot/firmware" = {
      device = "/dev/disk/by-label/FIRMWARE";
      fsType = "vfat";
    };
  };

  networking = {
    hostName = "vidar";
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
    wireless.iwd = {
      settings = {
        General.Country = "NL";
      };
    };
  };

  nixpkgs.hostPlatform = "aarch64-linux";

  programs = {
    fish.enable = true;
  };
  services = {
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
}
