{
  pkgs,
  ...
}:
{
  home.packages = [
    pkgs.talosctl # # TODO talosctl program
  ];
}
