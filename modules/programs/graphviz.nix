{
  flake.modules.generic.development'personal =
    {
      pkgs,
      lib,
      ...
    }:
    {
      environment.systemPackages = [
        pkgs.graphviz
      ];

      home-manager.sharedModules = [
        {
          programs.helix.extraPackages = lib.mkMerge [
            [
              pkgs.dot-language-server
            ]
          ];
        }
      ];
    };
}
