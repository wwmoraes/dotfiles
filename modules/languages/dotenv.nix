{
  flake.modules.homeManager.default = {
    programs.helix = {
      ignores = [
        "!.env*"
        "!*.env"
      ];

      languageSettings.env = {
        file-types = [
          { glob = ".*.env"; }
          { glob = ".env"; }
        ];
      };
    };
  };
}
