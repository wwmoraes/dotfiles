{
  config,
  ...
}:
{
  configurations.darwin.M1Cabuk = {
    contexts = [
      # keep-sorted start
      "personal"
      # keep-sorted end
    ];

    profiles = [
      # keep-sorted start
      "default"
      "development"
      "entertainment"
      "gpg"
      "gui"
      "messaging"
      "shell"
      "terminal"
      # keep-sorted end
    ];

    # commonHomeModules = with config.flake.modules.homeManager; [
    #   development
    # ];

    systemModules = with config.flake.modules; [
      darwin.single-user
    ];

    users.william = [ ];

    module = {
      imports = [ ];

      networking = {
        computerName = " M1 Cabuk";
        domain = "home.arpa";
        hostName = "M1Cabuk";
        localHostName = "M1Cabuk";
      };

      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  };
}
