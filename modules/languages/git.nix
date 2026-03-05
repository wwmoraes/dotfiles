{
  flake.modules.homeManager.default = {
    editorconfig.settings = {
      "*.{diff,patch}" = {
        charset = "unset";
        indent_size = "unset";
        indent_style = "unset";
        insert_final_newline = "unset";
        tab_width = "unset";
        trim_trailing_whitespace = "unset";
      };
    }
    // builtins.listToAttrs (
      builtins.map
        (name: {
          inherit name;
          value = {
            indent_size = "tab";
            indent_style = "tab";
            tab_width = 4;
          };
        })
        [
          ".config/git/*"
          ".git*"
          ".git/config"
        ]
    );

    programs.helix = {
      properties.languages.git-config.file-types = [
        { glob = ".config/git/*"; }
        { glob = ".git/config"; }
        { glob = ".gitattributes"; }
        { glob = ".gitconfig"; }
      ];

      settings.keys.normal = {
        ",".g = {
          b = ":echo %sh{git blame -C -C -C -L %{cursor_line},+1 %{buffer_name}}";
        };
      };
    };
  };
}
