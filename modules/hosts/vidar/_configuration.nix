{
  lib,
  ...
}:
{
  imports = [
    ./_hardware-configuration.nix
  ];

  boot = {
    # PL011 (UART0); assigned to bluetooth by default; fully-featured and
    # stable. Available as /dev/ttyAMA0
    #
    # requires "dtoverlay=disable-bt" in /boot/firmware/config.txt
    # remove any console assignment from /boot/firmware/cmdline.txt
    # disable hciuart and bluetooth systemd services as well
    #
    # Mini UART (UART1); GPIO 14 and 15, disabled by default; simpler but
    # frequency-dependant; locks CPU for a stable baud rate. Available at
    # /dev/ttyS0
    #
    # requires "enable_uart=1" in /boot/firmware/config.txt
    # requires "console=serial0,115200" in /boot/firmware/cmdline.txt
    # TODO: u-boot requires enable_uart=1; find alternatives
    # TODO: use declarative RPi config
    # see https://wiki.nixos.org/wiki/NixOS_on_ARM/Raspberry_Pi#Declarative_config.txt
    # see https://github.com/NixOS/nixos-hardware/blob/master/raspberry-pi/3/default.nix
    kernelParams = [
      # "console=ttyAMA0,115200n8"
      "console=ttyS0,115200n8"
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
