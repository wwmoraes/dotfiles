{
  lib,
  ...
}:
let
  inherit (lib) mkOption types;
in
{
  options = with types; {
    name = mkOption {
      type = str;
    };
    format = mkOption {
      type = bool;
      default = false;
    };
    fsType = mkOption {
      type = nullOr str;
      default = null;
    };
  };
}
