{
  config,
  lib,
  ...
}:
let
  listDirRegularPaths =
    root:
    map (lib.path.append root) (
      builtins.attrNames (lib.filterAttrs (_: v: v == "regular") (builtins.readDir root))
    );
in
{
  home.sessionVariables = {
    PROJECTS_DIR = "${config.home.homeDirectory}/workspace";
  };

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
    }) (listDirRegularPaths ./completions)
  );
}
