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
  options.programs.helix = {
    languageSettings = mkOption {
      default = null;
      apply = lib.filterAttrsRecursive (_: v: !builtins.isNull v);
      type = with types; nullOr (attrsOf (submodule ./settings.nix));
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
}
