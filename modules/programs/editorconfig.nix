{
  flake.modules.homeManager.development = {
    editorconfig = {
      enable = true;
      settings = {
        "*" = {
          charset = "utf-8";
          # end_of_line = "lf";
          indent_size = "tab";
          indent_style = "tab";
          insert_final_newline = true;
          tab_width = 2;
          trim_trailing_whitespace = true;
        };
      };
    };
  };
}
