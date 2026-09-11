{
  hosts.nixos.folkvangr =
    {
      getHomeModulesByName,
      getSystemModulesByName,
      ...
    }:
    {
      systemModules = getSystemModulesByName [
        # keep-sorted start
        "default"
        "home"
        "minisforum-ms-r1"
        "personal"
        "root"
        "secure-boot"
        "shell"
        "shell'personal"
        "william"
        # "gpg"
        # "hardening"
        # "media-server"
        # "nas"
        # keep-sorted end
      ];

      homeModules = getHomeModulesByName [
        # keep-sorted start
        "default"
        "home"
        "personal"
        # keep-sorted end
      ];

      userModules = {
        root = getHomeModulesByName [
        ];
        william = getHomeModulesByName [
          # keep-sorted start
          "shell"
          "shell'personal"
          # keep-sorted end
        ];
      };

      module = ./_configuration.nix;
    };
}
