{
  flake.modules.homeManager.default =
    {
      pkgs,
      ...
    }:
    {
      programs.helix = {
        extraPackages = [
          pkgs.regal
        ];

        languageSettings.rego.language-servers = [
          "regal"
          "regols"
        ];

        languages.language-server.regal = {
          command = "regal";
          args = [ "language-server" ];
          config.provideFormatter = true;
        };
      };
    };
}
