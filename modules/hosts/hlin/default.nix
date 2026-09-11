{
  hosts.nixos.hlin =
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
        "lenovo-ideapad-310"
        "personal"
        "root"
        "shell"
        "shell'personal"
        "william"
        # "secure-boot"
        # "gpg"
        # "hardening"
        # "media-server"
        # "nas"
        # "scm"
        # "nas-client"
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
