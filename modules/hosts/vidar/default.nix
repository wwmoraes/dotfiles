{
  hosts.nixos.vidar =
    {
      getHomeModulesByName,
      getSystemModulesByName,
      ...
    }:
    {
      systemModules = getSystemModulesByName [
        # keep-sorted start
        "default"
        "gpg"
        "personal"
        "root"
        "shell"
        "shell'personal"
        "william"
        # keep-sorted end
      ];

      homeModules = getHomeModulesByName [
        # keep-sorted start
        "default"
        "personal"
        # keep-sorted end
      ];

      userModules = {
        root = getHomeModulesByName [
          # keep-sorted start
          # keep-sorted end
        ];
        william = getHomeModulesByName [
          # keep-sorted start
          "gpg"
          "shell"
          "shell'personal"
          # keep-sorted end
        ];
      };

      module = ./_configuration.nix;
    };
}
