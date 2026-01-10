{
  flake.modules.homeManager.personal =
    {
      pkgs,
      ...
    }:
    {
      home.packages = [
        pkgs.talosctl # # TODO talosctl program
      ];
    };
}
