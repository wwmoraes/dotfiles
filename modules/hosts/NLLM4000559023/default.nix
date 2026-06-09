{
  config,
  ...
}:
{
  configurations.darwin.NLLM4000559023 = {
    contexts = [
      # keep-sorted start
      "work"
      # keep-sorted end
    ];

    profiles = [
      # keep-sorted start
      # "ai"
      "default"
      "development"
      "gpg"
      "gui"
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

    module = ./_configuration.nix;
  };
}
