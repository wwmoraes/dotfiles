{
  flake.modules.darwin.gui'personal = {
    system.defaults.timemachine.perUser.home.SkipPaths = [
      "Zotero"
    ];
  };

  flake.modules.homeManager.gui'personal =
    {
      pkgs,
      ...
    }:
    {
      home.packages = [
        pkgs.zotero
      ];
    };
}
