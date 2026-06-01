{
  flake.modules.generic.work = {
    nix.extraOptions = ''
      connect-timeout = 15
      http2 = false
      max-jobs = 1
      stalled-download-timeout = 600
    '';

    time.timeZone = "Europe/Amsterdam";
  };

  flake.modules.homeManager.work =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      ## TODO configure docker credentials
      # security add-internet-password -a C82334 -s p-nexus-3.development.nl.eu.abnamro.com -r htps -P 18447 -l "Docker Credentials" -w 'SECRET'
      # programs.docker.enable = true;
      programs.git.settings = {
        core.commentChar = "|";

        # diff = {
        #   ## SSNS is so bloated that even the sane defaults aren't enough
        #   renameLimit = 16384;
        # };

        credential = {
          "https://dev.azure.com" = {
            helper = lib.mkMerge [
              (lib.optionals (builtins.hasAttr "helper" config.programs.git.settings.credential) (
                builtins.getAttr "helper" config.programs.git.settings.credential
              ))
              (lib.mkAfter [
                (lib.getExe pkgs.nur.repos.wwmoraes.git-credential-azure)
              ])
            ];
            useHttpPath = true;
          };
          "https://p-bitbucket.nl.eu.abnamro.com:7999/scm/~82334/aab-userscripts.git".provider = "bitbucket";
          "https://p-bitbucket.nl.eu.abnamro.com:7999/scm/~82334/sharpener.git".provider = "bitbucket";
        };
      };

      programs.go = {
        env = {
          GOPRIVATE = [
            "https://dev.azure.com/cbsp-abnamro/*"
          ];
          GOPROXY = "https://p-nexus-3.development.nl.eu.abnamro.com:8443/repository/go-group,https://goproxy.io,direct";
          GOSUMDB = "sum.golang.org https://p-nexus-3.development.nl.eu.abnamro.com:8443/repository/go-sumdb";
        };
      };
    };

  flake.modules.darwin.work = {
    system.primaryUser = "william";
  };

  flake.modules.homeManager.william'work = {
    programs.ssh.matchBlocks."cocodev cocodev.pcs.nl.eu.abnamro.com" = {
      hostname = "cocodev.pcs.nl.eu.abnamro.com";
      user = "c82334";
    };
  };
}
