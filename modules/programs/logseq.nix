{
  flake.modules.darwin.gui'personal'disabled = {
    system.defaults.timemachine.perUser.home.SkipPaths = [
      ".logseq"
    ];
  };

  flake.modules.homeManager.gui'personal'disabled =
    {
      pkgs,
      ...
    }:
    {
      home.packages = [
        pkgs.logseq
      ];
    };
}
