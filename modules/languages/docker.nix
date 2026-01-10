{
  flake.modules.homeManager.default = {
    editorconfig.settings = builtins.listToAttrs (
      builtins.map
        (name: {
          inherit name;
          value = {
            indent_size = 2;
            indent_style = "space";
            tab_width = 2;
          };
        })
        [
          "*.Dockerfile"
          "Dockerfile"
        ]
    );
  };
}
