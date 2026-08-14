{
  flake.modules.generic.william =
    { config, ... }:
    {
      users.users.william = {
        description = "William Artero";
      };

      sops.gnupg.home = config.home-manager.users.william.programs.gpg.homedir;
    };

  flake.modules.darwin.william =
    {
      config,
      ...
    }:
    {
      system.defaults.timemachine.SkipPaths = [
        "${config.users.users.william.home}/Cloud"
        "${config.users.users.william.home}/dev"
      ];
    };

  flake.modules.nixos.william =
    {
      config,
      ...
    }:
    {
      # sops.secrets.williamHashedPassword = {
      #   neededForUsers = true;
      #   key = "users/william/hashedPassword";
      # };

      users.users.william = {
        isNormalUser = true;
        extraGroups = [
          "wheel"
        ];
        hashedPassword = "$y$jCT$LdkAFrLz10bguoptU7hs8.$FKokUbYUs4UrOZ1dZQtOLrY/eH6zhHvx3NRBrqo7I15";
        # hashedPasswordFile = config.sops.secrets.williamHashedPassword.path;
        shell = config.programs.fish.package;
      };
    };

  flake.modules.homeManager.william = {
    nix.settings.builders-use-substitutes = true;
    stylix.enable = true;
  };
}
