{
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

      options.programs.helix = {
        languageSettings = mkOption {
          default = null;
          apply = lib.filterAttrsRecursive (_: v: v != null);
          type = with types; nullOr (attrsOf (submodule ./_settings.nix));
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
          programs.helix.languages.language = lib.mapAttrsToList (
            name: value:
            value
            // {
              name = lib.mkOptionDefault name;
              grammar = lib.mkOptionDefault name;
            }
          ) (dropNullAttrs config.programs.helix.languageSettings);
        };
    };
}
