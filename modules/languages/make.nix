{
  flake.modules.homeManager.default = {
    editorconfig.settings = builtins.listToAttrs (
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
          "*.mk"
          "Makefile"
        ]
    );
  };
}
