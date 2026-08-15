{
  flake.modules.generic.default = {
    nix = {
      distributedBuilds = true;
      settings = {
        builders-use-substitutes = true;
      };
    };
  };

  flake.modules.darwin.personal = {
    # nix.linux-builder.enable = true;
    # nix.linux-builder.systems = lib.intersectLists lib.platforms.linux (
    #   lib.platforms.aarch64 ++ lib.platforms.x86_64
    # );

    nix.buildMachines = [
      {
        hostName = "vidar";
        maxJobs = 4;
        protocol = "ssh-ng";
        sshUser = "root";
        supportedFeatures = [
          "benchmark"
          "big-parallel"
          "kvm"
          "nixos-test"
        ];
        system = "aarch64-linux";
      }
      {
        hostName = "nas";
        maxJobs = 4;
        protocol = "ssh-ng";
        sshUser = "root";
        supportedFeatures = [
          "benchmark"
          "big-parallel"
          "kvm"
          "nixos-test"
        ];
        system = "x86_64-linux";
      }
    ];
  };
}
