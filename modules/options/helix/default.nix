{
  flake.modules.darwin.default =
    {
      ...
    }:
    {
      system.defaults.timemachine.perUser.home.SkipPaths = [
        ".config/helix/runtime/grammars"
      ];
    };

  flake.modules.homeManager.default =
    {
      lib,
      config,
      ...
    }:
    let
      inherit (lib) mkOption types mkIf;
      cfg = config.programs.helix;
    in
    {
      meta.maintainers = [
        lib.maintainers.wwmoraes or "wwmoraes"
      ];

      imports = [
        (lib.mkRenamedOptionModule
          [ "programs" "helix" "languageSettings" ]
          [ "programs" "helix" "properties" "languages" ]
        )
      ];

      options.programs.helix = {
        properties = {
          grammars = mkOption {
            default = { };
            apply = lib.filterAttrsRecursive (_: v: v != null);
            type = with types; attrs;
          };
          languages = mkOption {
            default = null;
            apply = lib.filterAttrsRecursive (_: v: v != null);
            type = with types; nullOr (attrsOf (submodule ./_settings.nix));
          };
        };
      };

      config =
        let
          dropNullAttrs = lib.concatMapAttrs (
            name: value:
            if value == null then
              { }
            else
              {
                ${name} = if builtins.isAttrs value then dropNullAttrs value else value;
              }
          );
        in
        mkIf cfg.enable {
          programs.helix.languages = {
            grammar = lib.mapAttrsToList (
              name: value:
              value
              // {
                name = lib.mkOptionDefault name;
              }
            ) (dropNullAttrs config.programs.helix.properties.grammars);
            language = lib.mapAttrsToList (
              name: value:
              value
              // {
                name = lib.mkOptionDefault name;
                grammar = lib.mkOptionDefault name;
              }
            ) (dropNullAttrs config.programs.helix.properties.languages);
          };
        };
    };
}
