{
  flake.modules.homeManager.william =
    {
      config,
      ...
    }:
    {
      nix.extraOptions = ''
        !include ${config.sops.templates.nixGithubAccessToken.path}
      '';

      sops = {
        secrets.githubToken.key = "github/token";

        templates.nixGithubAccessToken = {
          name = "nix-github-access-token.conf";
          content = ''
            access-tokens = github.com=${config.sops.placeholder.githubToken}
          '';
        };
      };
    };
}
