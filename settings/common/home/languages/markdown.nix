{
  pkgs,
  ...
}:
{
  editorconfig.settings."*.md" = {
    indent_size = 2;
    indent_style = "space";
    tab_width = 2;
  };

  programs.git = {
    attributes = [
      "*.md diff=markdown"
    ];
  };

  programs.helix.extraPackages = [
    pkgs.markdown-oxide
  ];
}
