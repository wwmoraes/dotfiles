{
  lib,
  ...
}:
let
  inherit (lib) mkOption types;
in
{
  options = with types; {
    location = mkOption {
      type = package;
      description = "";
    };
    digest = mkOption {
      type = nullOr str;
      default = null;
      defaultText = "";
      description = "";
    };
  };
}
