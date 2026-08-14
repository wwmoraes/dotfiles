{
  configurations.darwin.NLLM4000559023 =
    {
      getHomeModulesByName,
      getSystemModulesByName,
      ...
    }:
    {
      systemModules = getSystemModulesByName [
        # keep-sorted start
        "default"
        "development"
        "development'work"
        "gpg"
        "gui"
        "gui'work"
        "shell"
        "shell'work"
        "single-user"
        "william"
        "work"
        # keep-sorted end
      ];

      homeModules = getHomeModulesByName [
        # keep-sorted start
        "default"
        "work"
        # keep-sorted end
      ];

      userModules.william = getHomeModulesByName [
        # keep-sorted start
        "development"
        "development'work"
        "gpg"
        "gui"
        "gui'work"
        "shell"
        "shell'work"
        "william"
        "william'development"
        "william'work"
        # keep-sorted end
      ];

      module = ./_configuration.nix;
    };
}
