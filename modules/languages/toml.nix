{
  flake.modules.homeManager.default =
    {
      pkgs,
      ...
    }:
    {
      editorconfig.settings."*.toml" = {
        indent_size = 2;
        indent_style = "space";
        tab_width = 2;
      };

      programs.helix.extraPackages = [
        pkgs.unstable.taplo
      ];
    };
}
