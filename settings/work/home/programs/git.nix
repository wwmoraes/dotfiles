{
  config,
  pkgs,
  lib,
  ...
}:
{

  programs.git.settings = {
    core.commentChar = "|";

    # diff = {
    #   ## SSNS is so bloated that even the sane defaults aren't enough
    #   renameLimit = 16384;
    # };

    credential = {
      "https://dev.azure.com" = {
        helper = lib.mkMerge [
          config.programs.git.settings.credential.helper
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

}
