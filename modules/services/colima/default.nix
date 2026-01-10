{
  flake.modules.homeManager.development =
    {
      pkgs,
      lib,
      ...
    }:
    {
      services.colima = {
        enable = false;
        package = pkgs.colima.overrideAttrs (final: {
          patches = [
            ./colima.patch
          ];
          postPatch = ''
            substituteInPlace util/downloader/sha.go \
              --replace-fail '| shasum -a' '| ${lib.getExe' pkgs.perl "shasum"} -a'
          '';
        });
        profiles.default = {
          arch = "host";
          autoActivate = false;
          cpu = 2;
          disk = 80;
          forwardAgent = true;
          kubernetes.enabled = false;
          memory = 2;
          mountInotify = false;
          network.hostAddresses = true;
          rosetta = true;
          sshConfig = false;
          vmType = "vz";

          docker = {
            builder = {
              features = {
                buildkit = true;
              };
              gc = {
                defaultKeepStorage = "20GB";
                enabled = true;
              };
            };
            debug = false;
            experimental = false;
            features = {
              containerd-snapshotter = true;
            };
          };
        };
      };
    };
}
