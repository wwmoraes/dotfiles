{
  lib,
  ...
}:
{
  editorconfig = {
    enable = true;
    settings =
      {
        "*" = {
          charset = "utf-8";
          # end_of_line = "lf";
          indent_size = "tab";
          indent_style = "tab";
          insert_final_newline = true;
          tab_width = 2;
          trim_trailing_whitespace = true;
        };
      }
      //
        lib.genAttrs
          [
            # 2-width tab convention
          ]
          (_: {
            indent_size = "tab";
            indent_style = "tab";
            tab_width = 2;
          })
      //
        lib.genAttrs
          [
            # 4-width tab convention
            "*.{go,mk}"
            ".config/git/*"
            ".git*"
            ".git/*"
            "Makefile"
            "go.{mod,work}"
          ]
          (_: {
            indent_size = "tab";
            indent_style = "tab";
            tab_width = 4;
          })
      //
        lib.genAttrs
          [
            # 2 spaces convention
            "*.{Dockerfile,json.md,nix,toml,yaml,yml}"
            "Dockerfile"
          ]
          (_: {
            indent_size = 2;
            indent_style = "space";
            tab_width = 2;
          })
      //
        lib.genAttrs
          [
            # 4 spaces convention
            "*.{fish}"
          ]
          (_: {
            indent_size = 4;
            indent_style = "space";
            tab_width = 4;
          })
      //
        lib.genAttrs
          [
            # generated content
            "*.lock"
            "*.{diff,patch}"
            ".direnv/**"
            ".git/**"
          ]
          (_: {
            charset = "unset";
            indent_size = "unset";
            indent_style = "unset";
            insert_final_newline = "unset";
            tab_width = "unset";
            trim_trailing_whitespace = "unset";
          });
  };
}
