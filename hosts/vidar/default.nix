# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
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
    };
  };

  environment.shellInit = ''
    gpgconf --kill gpg-agent || true
    gpgconf --create-socketdir 2>&1 >/dev/null || true
  '';

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

  home-manager.users = {
    root = {
      # imports = [
      #   ../../users/william/share/home/programs/gpg
      # ];
      programs.bash.enable = true;
      services.gpg-agent = {
        enable = lib.mkForce false;
      };
      systemd.user.sessionVariables = {
        inherit (config.home-manager.users.root.home.sessionVariables) GNUPGHOME;
      };
    };
    william = {
      programs = {
        bash.enable = true;
        fish.enable = true;
      };

      services.gpg-agent = {
        enable = lib.mkForce false;
      };
    };
  };

  # i18n.defaultLocale = "en_US.UTF-8";

  networking.domain = "home.arpa";
  networking.hostName = "vidar";
  networking.networkmanager.enable = true;

  nix = {
    settings = {
      extra-experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  programs = {
    dconf.enable = true; # needed by home-manager somehow
    fish.enable = true;
  };

  services.openssh = {
    enable = true;
    settings = {
      AcceptEnv = "ZELLIJ";
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

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

  time.timeZone = "Europe/Amsterdam";

  users = {
    mutableUsers = false;
    users = {
      root = {
        hashedPassword = "$y$j9T$mHDXOLhUUNq3c91YRRcLX0$u9h/E52hXlYlrZg7.aaXy4QBazH3PLOCxyEiPLMNtT/";
        openssh.authorizedKeys.keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDEQfDq8il7eWmG9om/Oqlkd842nSpb/W2A44Yp2RDSHDFKddjSGxpB3phN1eQieymqJMFofdHahdLoxXIItJH5D0ixT/dKCNduZosN1fpJu6pcPaMZ8lxzxMKcNswZ3j9Hitk9lMX/x/Y3h9uBv/nHbpPxxGmxJM7bze9RVYAcEZIvrFib2VFp62k7DHMgQzOUm+s4moa2uvc3JXKtjYdqVq+pdryubYn1BRxkBDc5TH9WIIEKAkDUV+kYIslFs4orlWZXd2yKKqGXM+5pK5ybiEo2mGiooXr1hBXSvGPbpeWNmHqEl8AKY3MRgwbt/eqVk9YkGZh/w0Go5Cus1KHdNccApkt1ItX30+caDRgpDN47pPtMs7onNvPoYEaG0CgGOQa9SjcXd0GSi6X2HVA9FLnkT3rsUTrkwOz9pEAkBqYTPfVoKnfhmfInZt/7JiKAbGSw93O6du5pvQkDpG7aRtfCIoRK642ClG2yqqSPv7uoQi2EWMHSFnCSmW+uIL5Lj2DUdeKoB01KtgZYXAGKJseAvP8FXiQfBh8PHXwNaQQ0fBeI5DOXpIJXvjV9XdnkeA1T+W+m3r7QzhR6K4lOBx8gNXJ7p5x8+JZ5B0FbN0Qnbg7t15cUWJyD8xMABca1JyuBpt/jO0F/chyzqI8sDp201Hd67lJxPaN3x09ZrQ== openpgp:0x78133BF7"
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC/gOwc6RLeXcdlEjiduZsm5wJmTDAsN7fAs2suNavqeXESIVshRsih478c43h18tKyFYZACgHmEk2tJg0NO+VDWFaeQPfc+BUQyhlbCNgC+U6dH1ciTuFntzjv9Hbc21EdImkD+fVaVCkbf4EC3BgtkDkOUuE3R2GSg5CxpvJ2OBWBrb0tbpK4+NqRzfI4U0/q1441ZbJqusDuQoVEEdP9XuOgbhostdx8pASJHnTJiasfgFsZa+p7Va1BJ2KjHTw2cE9ENEwKrJ06IVbmEzbi8M9MOAqQ8lhUUxXUhIBLi+vDZh0hmGSSz8xVUipAJa/DQF2mG05ktJIDywktxpLvSNcFo7ahenoiMoeSqz1UEyH/ZGMO+1IYHPYlmG2SRzXPL1Wjs0qkYB1K/B4xBSMZvCZK+v7KXtyj/s8TvR6izG8fMdTaIWRycQe6TQAzWlxLSXT+iahkuxMF9fQckkLrWn4ye4uaicyfhzqV55fMDu2QuBdV8tRmAgyDFzQIcGwkVe4oy8YQ+u+lOu902WyI8wASEPvX6MAshHyHEciTsCdT3/ETTh94mQnx8ffg0ZSsxy0uiKVEKuqbkYgE+Nzp5qqGgdSBjVj+PhuepWJ7v4TTAsKKbWEAuLjnvOzOEWycOuzsQsgXBErnHB2boqtgoNZZVDgx8pmG2oyBpb5SnQ== openpgp:0xC53A52E1"
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCcIIbYj1zxMLN2KnYuKiluSQtvge4f1ZEgVlDqFSThKdjID6y+wtgo+Usy0Os0KV/YyhtNd1dKXisowUIQQCOOPZrBvlCKj+u1051bkEwu/3E55F/T36YjH9e7PT+7f89PMkwQ4XV2tf29xqaBAqxIF6dlyBarC+0j3VyrTlFD3UJQ+7D9IGzQKXrTkEu3lFYGcanmHXJ6n9mksJGthwkj2cem/5cyhC/+oVlBRnaZ+Wk56rKG7WHOEXJYr68TZtXOt/W+sRElchI9cA42K2D+wJi3tANp3ShNjblihayrRhGa/rZsRTuLSap9QUmsNOTektriMNdqG5MTHVV9wsBdr8V9YgvlJU5RJyVGu8Xn1aYwIrVDUpSo5lw7g/z7LLhnmK6ttxNQ1m1lJEBQWSC8Y1hONrrvAv6KyL/lVxLeKtQTOc9H9gH1GMR8EinekjQa56IXB5UHDp3C3Rf4abGy/aUjgtDJh7bJ9IR1J+Od8v5LqUnWzIb/uoydkrqi8V9E+90xZ099DRaDZY8LLWgmhRCf/TvfDqJNMEfVyj5jeeN1E15egU5iE4Z0Rlgk1YVZoGqE4n2MPmQ058hbvPBuFkYUjYAgzQHOkqDyplk/Soo2j3uVFJ2f8dfrzG9uwdTO+gFsDQhrGRZEvyMQNk+R4sY1gfGxr85VOCtr6FdJfQ== openpgp:0x3CAA9D88"
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC4WES78B50maGZu/NZwcgGUFIkj3kJxl7ryDYOyqZSPFruuLEPeP7EP32paj9WaLp43vrFAYh1Yede39v3DWmNfaTbgEAdz7EDJSkUyt2EmHYPljkFbSXJFTxkT4pA86R7Z06Cr+AhUb0nbAa9eJ7ifcUEAjoGao70ZrrywlVWKekH7SA7H51Ks/zknphtNpqZ4q+ARMtO5sFWkJYpoDJQozS1AUH1flVdNFrDC/l9jBggOrQn6CUkoi/pMDHKMipjye8r0LroYfKG2PNsJ0FwGAbZjzus787JbKvHzFuEjRgTPGoZgKgZ3sgioEJ9Q2J+3rkBNdexvTSmvgoKaq8T6pKDNE3fZyaPXZo6ZPy2llwQ4BBtd3GhoP6B6itSPmaDxCLC9Fmdl/Azq26sRQ6jDgzdZnc1oP3E7dCEOb4CsuwjazDyVDjukmbqyGINkIYf+uxJ1OILWG8lwRVxqqYWKIodAaqCwJddkxy0UJDBSBexAmvWHSfIrrx5YPveksldoD7/tVbqDCTGsb6ztesMJlVIg0DMNmiuiHauS5Ywxvvn1CoSfCru+0HVqdayIRoZ6bZCvF3r5vA2oyRz6lBXdME8CdYxkl8jd+6faQEp+8E6/T0//x73y13bMnr/7XO+03XTWQpqlzLsuC5SDkAfK9r/FGsNZZiDu8Qs7KDCuw== openpgp:0x196A28F6"
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQD0hZAxWk0hoBupHolla2VJgawGw4ozZLtQjaRB33biFIFeQyd+zgu1ppDUUIaLnXaMWccfqTuRtp3WQUv6lbxB6gFSuHlIOd2tVEvboyCEYu1taGlMZODQQroIn/ytL0BFid9fgKi3ft6EEF7XCGGwbjOcNEOVmt4PppfiwEJrzjmBU0MJp+YCC0bxSG8DbQj6pe2vKRo/hYqgjjOifVXAdDqtWSSL/U0woTKebpBvQu0HbmdOL5zD2X6GCfZNU/SDDM717CKkJDpiDt882wkcHdWmeFpL89tEzt9O0l4DybrCs0LAQTlqYqqofr4QNdER/dcZ1tr0+eKAXJo3M9YTscTYtLYU8UKC3CyfBcQuYPiioy0gxATBkI/2gRkn9t3pPbjMkfN8EDLbrb+bf2huB6ES+J4ZmCd/gWMinrpSlcsosUAi3Rfyn4KAKJxR/VEw+AhAj5pq26TVKOhidbIA89lIkjuFFEMbtxyALfTtToGX/GxtYrvb/skmpTMa9JdBNEv7ppLHTdYeSvwCqK8XvSCNTs7jeRmglYshdvUggWx9bZXUALA7/oCMEYvCo+C4Bj5tLLvhLPQmn6lokJc0KKHnoQ2A4x7EIkKC03mYcKYCeOlzRiMV+SJxwHA2Vc8GLLfnUZRAw0fujjSPXLC0PB0I7ASrMMRAJCNGlPLy2Q== openpgp:0xCCB310CC"
        ];
        shell = config.programs.fish.package;
      };
      william = {
        isNormalUser = true;
        extraGroups = [
          "wheel"
        ];
        hashedPassword = "$y$j9T$mTI8Jz6.5oYDZ1QzP1yRz.$2WjZd3.4Ceosh1YbzImP8kgyP8kxTBQj1MIqbe2BQMA";
        openssh.authorizedKeys.keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDEQfDq8il7eWmG9om/Oqlkd842nSpb/W2A44Yp2RDSHDFKddjSGxpB3phN1eQieymqJMFofdHahdLoxXIItJH5D0ixT/dKCNduZosN1fpJu6pcPaMZ8lxzxMKcNswZ3j9Hitk9lMX/x/Y3h9uBv/nHbpPxxGmxJM7bze9RVYAcEZIvrFib2VFp62k7DHMgQzOUm+s4moa2uvc3JXKtjYdqVq+pdryubYn1BRxkBDc5TH9WIIEKAkDUV+kYIslFs4orlWZXd2yKKqGXM+5pK5ybiEo2mGiooXr1hBXSvGPbpeWNmHqEl8AKY3MRgwbt/eqVk9YkGZh/w0Go5Cus1KHdNccApkt1ItX30+caDRgpDN47pPtMs7onNvPoYEaG0CgGOQa9SjcXd0GSi6X2HVA9FLnkT3rsUTrkwOz9pEAkBqYTPfVoKnfhmfInZt/7JiKAbGSw93O6du5pvQkDpG7aRtfCIoRK642ClG2yqqSPv7uoQi2EWMHSFnCSmW+uIL5Lj2DUdeKoB01KtgZYXAGKJseAvP8FXiQfBh8PHXwNaQQ0fBeI5DOXpIJXvjV9XdnkeA1T+W+m3r7QzhR6K4lOBx8gNXJ7p5x8+JZ5B0FbN0Qnbg7t15cUWJyD8xMABca1JyuBpt/jO0F/chyzqI8sDp201Hd67lJxPaN3x09ZrQ== openpgp:0x78133BF7"
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC/gOwc6RLeXcdlEjiduZsm5wJmTDAsN7fAs2suNavqeXESIVshRsih478c43h18tKyFYZACgHmEk2tJg0NO+VDWFaeQPfc+BUQyhlbCNgC+U6dH1ciTuFntzjv9Hbc21EdImkD+fVaVCkbf4EC3BgtkDkOUuE3R2GSg5CxpvJ2OBWBrb0tbpK4+NqRzfI4U0/q1441ZbJqusDuQoVEEdP9XuOgbhostdx8pASJHnTJiasfgFsZa+p7Va1BJ2KjHTw2cE9ENEwKrJ06IVbmEzbi8M9MOAqQ8lhUUxXUhIBLi+vDZh0hmGSSz8xVUipAJa/DQF2mG05ktJIDywktxpLvSNcFo7ahenoiMoeSqz1UEyH/ZGMO+1IYHPYlmG2SRzXPL1Wjs0qkYB1K/B4xBSMZvCZK+v7KXtyj/s8TvR6izG8fMdTaIWRycQe6TQAzWlxLSXT+iahkuxMF9fQckkLrWn4ye4uaicyfhzqV55fMDu2QuBdV8tRmAgyDFzQIcGwkVe4oy8YQ+u+lOu902WyI8wASEPvX6MAshHyHEciTsCdT3/ETTh94mQnx8ffg0ZSsxy0uiKVEKuqbkYgE+Nzp5qqGgdSBjVj+PhuepWJ7v4TTAsKKbWEAuLjnvOzOEWycOuzsQsgXBErnHB2boqtgoNZZVDgx8pmG2oyBpb5SnQ== openpgp:0xC53A52E1"
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCcIIbYj1zxMLN2KnYuKiluSQtvge4f1ZEgVlDqFSThKdjID6y+wtgo+Usy0Os0KV/YyhtNd1dKXisowUIQQCOOPZrBvlCKj+u1051bkEwu/3E55F/T36YjH9e7PT+7f89PMkwQ4XV2tf29xqaBAqxIF6dlyBarC+0j3VyrTlFD3UJQ+7D9IGzQKXrTkEu3lFYGcanmHXJ6n9mksJGthwkj2cem/5cyhC/+oVlBRnaZ+Wk56rKG7WHOEXJYr68TZtXOt/W+sRElchI9cA42K2D+wJi3tANp3ShNjblihayrRhGa/rZsRTuLSap9QUmsNOTektriMNdqG5MTHVV9wsBdr8V9YgvlJU5RJyVGu8Xn1aYwIrVDUpSo5lw7g/z7LLhnmK6ttxNQ1m1lJEBQWSC8Y1hONrrvAv6KyL/lVxLeKtQTOc9H9gH1GMR8EinekjQa56IXB5UHDp3C3Rf4abGy/aUjgtDJh7bJ9IR1J+Od8v5LqUnWzIb/uoydkrqi8V9E+90xZ099DRaDZY8LLWgmhRCf/TvfDqJNMEfVyj5jeeN1E15egU5iE4Z0Rlgk1YVZoGqE4n2MPmQ058hbvPBuFkYUjYAgzQHOkqDyplk/Soo2j3uVFJ2f8dfrzG9uwdTO+gFsDQhrGRZEvyMQNk+R4sY1gfGxr85VOCtr6FdJfQ== openpgp:0x3CAA9D88"
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC4WES78B50maGZu/NZwcgGUFIkj3kJxl7ryDYOyqZSPFruuLEPeP7EP32paj9WaLp43vrFAYh1Yede39v3DWmNfaTbgEAdz7EDJSkUyt2EmHYPljkFbSXJFTxkT4pA86R7Z06Cr+AhUb0nbAa9eJ7ifcUEAjoGao70ZrrywlVWKekH7SA7H51Ks/zknphtNpqZ4q+ARMtO5sFWkJYpoDJQozS1AUH1flVdNFrDC/l9jBggOrQn6CUkoi/pMDHKMipjye8r0LroYfKG2PNsJ0FwGAbZjzus787JbKvHzFuEjRgTPGoZgKgZ3sgioEJ9Q2J+3rkBNdexvTSmvgoKaq8T6pKDNE3fZyaPXZo6ZPy2llwQ4BBtd3GhoP6B6itSPmaDxCLC9Fmdl/Azq26sRQ6jDgzdZnc1oP3E7dCEOb4CsuwjazDyVDjukmbqyGINkIYf+uxJ1OILWG8lwRVxqqYWKIodAaqCwJddkxy0UJDBSBexAmvWHSfIrrx5YPveksldoD7/tVbqDCTGsb6ztesMJlVIg0DMNmiuiHauS5Ywxvvn1CoSfCru+0HVqdayIRoZ6bZCvF3r5vA2oyRz6lBXdME8CdYxkl8jd+6faQEp+8E6/T0//x73y13bMnr/7XO+03XTWQpqlzLsuC5SDkAfK9r/FGsNZZiDu8Qs7KDCuw== openpgp:0x196A28F6"
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQD0hZAxWk0hoBupHolla2VJgawGw4ozZLtQjaRB33biFIFeQyd+zgu1ppDUUIaLnXaMWccfqTuRtp3WQUv6lbxB6gFSuHlIOd2tVEvboyCEYu1taGlMZODQQroIn/ytL0BFid9fgKi3ft6EEF7XCGGwbjOcNEOVmt4PppfiwEJrzjmBU0MJp+YCC0bxSG8DbQj6pe2vKRo/hYqgjjOifVXAdDqtWSSL/U0woTKebpBvQu0HbmdOL5zD2X6GCfZNU/SDDM717CKkJDpiDt882wkcHdWmeFpL89tEzt9O0l4DybrCs0LAQTlqYqqofr4QNdER/dcZ1tr0+eKAXJo3M9YTscTYtLYU8UKC3CyfBcQuYPiioy0gxATBkI/2gRkn9t3pPbjMkfN8EDLbrb+bf2huB6ES+J4ZmCd/gWMinrpSlcsosUAi3Rfyn4KAKJxR/VEw+AhAj5pq26TVKOhidbIA89lIkjuFFEMbtxyALfTtToGX/GxtYrvb/skmpTMa9JdBNEv7ppLHTdYeSvwCqK8XvSCNTs7jeRmglYshdvUggWx9bZXUALA7/oCMEYvCo+C4Bj5tLLvhLPQmn6lokJc0KKHnoQ2A4x7EIkKC03mYcKYCeOlzRiMV+SJxwHA2Vc8GLLfnUZRAw0fujjSPXLC0PB0I7ASrMMRAJCNGlPLy2Q== openpgp:0xCCB310CC"
        ];
        shell = config.programs.fish.package;
      };
    };
  };

  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };
}
