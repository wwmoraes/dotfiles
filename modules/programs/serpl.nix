{
  flake.modules.homeManager.shell'personal =
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
            ":insert-output serpl >/dev/tty"
            ":redraw"
            ":reload-all"
          ];
        };
      };
    };
}
