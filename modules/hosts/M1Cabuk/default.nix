{
  hosts.darwin.M1Cabuk =
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
        "development'personal"
        "gpg"
        "gui"
        "gui'personal"
        "home"
        "messaging"
        "messaging'personal"
        "multi-user"
        "personal"
        "role'workstation"
        "root"
        "shell"
        "shell'personal"
        "terminal"
        "terminal'personal"
        "william"
        # "profile'development"
        # keep-sorted end
      ];

      homeModules = getHomeModulesByName [
        # keep-sorted start
        "default"
        "home"
        "personal"
        # "development"
        # keep-sorted end
      ];

      userModules.root = [ ];
      userModules.william = getHomeModulesByName [
        # keep-sorted start
        "ai'personal"
        "development"
        "development'personal"
        "gpg"
        "gui"
        "gui'personal"
        "messaging"
        "messaging'personal"
        "profile'development"
        "profile'signing"
        "shell"
        "shell'personal"
        "terminal"
        "terminal'personal"
        "william"
        "william'development"
        "william'personal"
        # keep-sorted end
      ];

      module = ./_configuration.nix;
    };
}
