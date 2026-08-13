{
  configurations.darwin.M1Cabuk = {
    contexts = [
      # keep-sorted start
      "personal"
      # keep-sorted end
    ];

    profiles = [
      # keep-sorted start
      "ai"
      "default"
      "development"
      "entertainment"
      "gpg"
      "gui"
      "messaging"
      "multi-user"
      "shell"
      "terminal"
      # keep-sorted end
    ];

    # commonHomeModules = with config.flake.modules.homeManager; [
    #   development
    # ];

    # systemModules = with config.flake.modules; [
    #   darwin.single-user
    #   darwin.multi-user
    # ];

    users.william = [ ];

    module = ./_configuration.nix;
  };
}
