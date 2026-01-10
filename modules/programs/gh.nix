{
  lib,
  ...
}:
{
  flake.modules.homeManager.development =
    {
      config,
      lib,
      ...
    }:
    {
      programs.gh = {
        gitCredentialHelper.enable = false;
        enable = true;
        settings = {
          git_protocol = "ssh";
        };
      };

      programs.git.settings.credential = lib.optionalAttrs config.programs.gh.gitCredentialHelper.enable (
        builtins.listToAttrs (
          map (
            host:
            lib.nameValuePair host {
              helper = lib.mkMerge [
                (lib.optionals (builtins.hasAttr "helper" config.programs.git.settings.credential) (
                  builtins.getAttr "helper" config.programs.git.settings.credential
                ))
                (lib.mkAfter [
                  "${lib.getExe config.programs.gh.package} auth git-credential"
                ])
              ];
            }
          ) config.programs.gh.gitCredentialHelper.hosts
        )
      );
    };

  flake.modules.homeManager.development'work = {
    programs.gh = {
      extensions = [
        # pkgs.gh-copilot ## thank you CISO for blocking it...
      ];
      settings = {
        ## thank you CISO...
        git_protocol = lib.mkForce "https";
      };
    };
  };

  flake.modules.homeManager.william'development = {
    programs.gh.hosts = {
      "github.com" = {
        users = [
          "wwmoraes"
        ];
        user = lib.mkDefault "wwmoraes";
      };
    };

  };

  flake.modules.homeManager.william'work = {
    programs.gh.hosts."github.com".users = [
      "william-moraes-artero_abnamroc"
    ];
  };
}
