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

  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub.enable = false;
    systemd-boot.enable = true;
  };

  boot.kernelParams = [
    "console=ttyS0,115200n8"
    "console=tty0"
  ];

  # fileSystems = {
  #   "/" = {
  #     device = "/dev/disk/by-label/nixos";
  #     fsType = "ext4";
  #   };

  #   "/boot" = {
  #     device = "/dev/disk/by-label/ESP";
  #     fsType = "vfat";
  #   };
  # };

  networking = {
    hostName = "folkvangr";
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
    wireless.iwd = {
      enable = true;
      settings = {
        General.Country = "NL";
      };
    };
  };

  nixpkgs.hostPlatform = "aarch64-linux";

  programs.dconf.enable = true; # needed by home-manager somehow
  programs.fish.enable = true;

  services.openssh = {
    enable = true;
    settings = {
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

  system.stateVersion = "25.11";
}
