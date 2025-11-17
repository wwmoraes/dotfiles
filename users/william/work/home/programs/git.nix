{
  programs.git = {
    extraConfig = {
      user = {
        handle = "artero";
      };
    };

    includes =
      map
        (url: {
          contents = rec {
            user.email = "william.moraes.artero@nl.abnamro.com";
            author = {
              inherit (user) email;
            };
            committer = {
              inherit (user) email;
            };
          };
          condition = "hasconfig:remote.*.url:${url}";
        })
        [
          "https://cbsp-abnamro@dev.azure.com/**"
          "https://p-bitbucket.nl.eu.abnamro.com:7999/**"
        ];
  };
}
