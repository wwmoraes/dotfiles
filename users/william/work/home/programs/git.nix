{
  programs.git.includes =
    map
      (url: {
        contents = rec {
          author = {
            inherit (user) email;
          };
          committer = {
            inherit (user) email;
          };
          user = {
            email = "william.moraes.artero@nl.abnamro.com";
            handle = "artero";
          };
        };
        condition = "hasconfig:remote.*.url:${url}";
      })
      [
        "https://cbsp-abnamro@dev.azure.com/**"
        "https://p-bitbucket.nl.eu.abnamro.com:7999/**"
      ];
}
