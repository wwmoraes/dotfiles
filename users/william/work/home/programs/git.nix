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
          contents = {
            user.email = "william.moraes.artero@nl.abnamro.com";
          };
          condition = "hasconfig:remote.*.url:${url}";
        })
        [
          "https://cbsp-abnamro@dev.azure.com/**"
          "https://p-bitbucket.nl.eu.abnamro.com:7999/**"
        ];
  };
}
