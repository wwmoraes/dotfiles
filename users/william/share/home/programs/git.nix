{
  config,
  lib,
  ...
}:
{
  programs.git = {
    settings = {
      author = {
        inherit (config.programs.git.settings.user) email name;
      };
      committer = {
        inherit (config.programs.git.settings.user) email name;
      };
      user = {
        email = "git@artero.dev";
        handle = lib.mkDefault "wwmoraes";
        name = "William Artero";
      };
    };
    signing = {
      key = config.programs.gpg.settings.default-key;
    };
  };

  xdg.configFile = {
    "git/mailmap" = {
      text = ''
        William Artero <git@artero.dev>
        William Artero <git@artero.dev> <github@artero.dev>
        William Artero <git@artero.dev> <william.artero@dafiti.com.br>
        William Artero <git@artero.dev> <william.moraesartero@messagebird.com>
        William Artero <git@artero.dev> <william@artero.dev>
        William Artero <git@artero.dev> <william@dft-sp-wkn623.dafiti.local>
        William Artero <git@artero.dev> <williamwmoraes@gmail.com>
        William Artero <git@artero.dev> <wwmoraes@users.noreply.github.com>
        GitHub Actions <actions@github.com>
        GitHub Actions <actions@github.com> <41898282+github-actions[bot]@users.noreply.github.com>
        GitHub Actions <actions@github.com> <49699333+dependabot[bot]@users.noreply.github.com>
        GitHub Actions <actions@github.com> <49736102+kodiakhq[bot]@users.noreply.github.com>
        GitHub Actions <actions@github.com> <66853113+pre-commit-ci[bot]@users.noreply.github.com>
      '';
    };
  };
}
