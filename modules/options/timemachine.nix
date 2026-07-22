{
  flake.modules.darwin.default =
    {
      config,
      lib,
      ...
    }:
    let
      cfg = config.system.defaults.timemachine;
    in
    {
      meta.maintainers = [
        lib.maintainers.wwmoraes or "wwmoraes"
      ];

      options.system.defaults.timemachine = {
        SkipPaths = lib.mkOption {
          type = lib.types.listOf lib.types.path;
          default = [ ];
        };
        perUser.home.SkipPaths = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
        };
      };

      config = {
        system.defaults.CustomSystemPreferences."/Library/Preferences/com.apple.TimeMachine" = {
          SkipPaths =
            cfg.SkipPaths
            ++ (
              config.users.users
              |> builtins.attrValues
              |> builtins.concatMap (
                user:
                lib.optionals (user.home != null) (
                  map (lib.path.append (/. + user.home)) cfg.perUser.home.SkipPaths
                )
              )
            );
        };
      };
    };
}
