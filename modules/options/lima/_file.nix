{
  lib,
  ...
}:
let
  inherit (lib) mkOption types;
in
{
  options = with types; {
    url = mkOption {
      type = package;
      description = ''
        Path to the file.
      '';
    };
    digest = mkOption {
      type = nullOr str;
      default = null;
      description = ''
        The "digest" property is currently unused.
      '';
    };
  };
}
