{
  pkgs,
  ...
}:
{
  home.packages = [
    pkgs.serpl
  ];

  programs.helix = {
    settings.keys = {
      normal.A-r = [
        ":write-all"
        ":insert-output serpl --no-stdin >/dev/tty"
        ":redraw"
        ":reload-all"
      ];
    };
  };
}
