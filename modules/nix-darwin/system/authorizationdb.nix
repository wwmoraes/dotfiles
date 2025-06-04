{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    concatStringsSep
    filterAttrs
    mapAttrsToList
    mkOption
    types
    ;
  cfg = config.system;
  writeAuthorizationDB = key: value: ''
    echo -n "${key} => ${value}: "
    security authorizationdb write ${key} ${value}
  '';
  authorizationDBToList =
    attrs: mapAttrsToList writeAuthorizationDB (filterAttrs (n: v: v != null) attrs);
in
{
  meta.maintainers = [
    lib.maintainers.wwmoraes or "wwmoraes"
  ];

  options = {
    system.authorizationDB = mkOption {
      type = with types; attrsOf str;
      default = { };
      example = {
        "system.privilege.taskport" = "authenticate-developer";
      };
      description = ''
        A set of MacOS Authorization DB rights and rules to apply.

        Make sure you know what you're doing; these can make or break your OS!
      '';
    };
  };
  config = {
    system.activationScripts = {
      extraActivation.text = lib.mkAfter config.system.activationScripts.authorizationDB.text;
      authorizationDB.text = ''
        echo >&2 "configuring authorization DB..."
        ${concatStringsSep "\n" (authorizationDBToList cfg.authorizationDB)}
      '';
    };
  };
}
