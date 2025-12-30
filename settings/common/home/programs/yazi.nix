{
  pkgs,
  ...
}:
{
  home.packages = [
    pkgs.yazi
  ];

  programs.helix = {
    settings.keys.normal = {
      ",".e = [
        ":write-all"
        ":insert-output yazi >/dev/tty"
        ":redraw"
        ":reload-all"
      ];
      A-e = [
        ":write-all"
        ":insert-output yazi >/dev/tty"
        ":redraw"
        ":reload-all"
      ];
    };
  };
}
