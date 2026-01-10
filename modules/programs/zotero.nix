{
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
