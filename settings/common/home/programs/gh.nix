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

  programs.git.extraConfig.credential = builtins.listToAttrs (
    map (
      host:
      lib.nameValuePair host {
        helper = lib.mkMerge [
          config.programs.git.extraConfig.credential.helper
          (lib.mkAfter [
            "${lib.getExe config.programs.gh.package} auth git-credential"
          ])
        ];
      }
    ) config.programs.gh.gitCredentialHelper.hosts
  );
}
