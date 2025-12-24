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

  programs.git.settings.credential = builtins.listToAttrs (
    map (
      host:
      lib.nameValuePair host {
        helper = lib.mkMerge [
          config.programs.git.settings.credential.helper
          (lib.mkAfter [
            "${lib.getExe config.programs.gh.package} auth git-credential"
          ])
        ];
      }
    ) config.programs.gh.gitCredentialHelper.hosts
  );
}
