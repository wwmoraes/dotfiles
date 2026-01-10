{
  flake.modules.homeManager.work =
    {
      pkgs,
      ...
    }:
    {
      programs.fish = {
        functions = {
          work = {
            argumentNames = "cmd";
            body = builtins.readFile ./functions/work.fish;
            description = "work utilities so I can stay productive";
          };
        };
      };

      xdg.configFile = builtins.listToAttrs (
        builtins.map (path: {
          name = "fish/completions/${builtins.baseNameOf path}";
          value = {
            executable = true;
            source = path;
          };
        }) (pkgs.lib.local.listDirRegularPaths ./completions)
      );
    };
}
