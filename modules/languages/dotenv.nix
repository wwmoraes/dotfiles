{
  flake.modules.homeManager.default = {
    programs.helix = {
      ignores = [
        "!.env*"
        "!*.env"
      ];

      properties.languages.env = {
        file-types = [
          { glob = ".*.env"; }
          { glob = ".env"; }
        ];
      };
    };
  };
}
