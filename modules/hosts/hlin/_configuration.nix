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

  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub.enable = false;
    systemd-boot.enable = true;
  };

  console.keyMap = "br-abnt2";

  networking = {
    hostName = "hlin";
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
    wireless.iwd = {
      enable = true;
      settings = {
        General.Country = "NL";
      };
    };
  };

  programs.fish.enable = true;

  services = {
    openssh = {
      enable = true;
      settings = {
        MaxSessions = 20;
        MaxStartups = "10:20:50";
        StreamLocalBindUnlink = true;
      };
    };
  };

  system.stateVersion = "26.05";

  users.mutableUsers = false;
}
