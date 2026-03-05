{
  flake.modules.homeManager.default = {
    programs.git = {
      attributes = [
        "*.bash diff=bash"
      ];
    };

    programs.helix = {
      properties.languages.bash = {
        file-types = [
          "bash"
          { glob = ".envrc"; }
          { glob = ".bash_*"; }
        ];
      };
    };
  };
}
