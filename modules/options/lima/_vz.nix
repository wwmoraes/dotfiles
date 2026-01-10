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
      type = nullOr str;
      default = null;
      defaultText = lib.literalMD ''
        Lima built-in default: same as the host username, if it is a valid Linux username, otherwise "lima"
      '';
      description = ''
        User name. An explicitly specified username is not validated by Lima.
      '';
    };
    comment = mkOption {
      type = nullOr str;
      default = null;
      defaultText = lib.literalMD ''
        Lima built-in default: user information from the host
      '';
      description = ''
        Full name or display name of the user.
      '';
    };
    uid = mkOption {
      type = nullOr ints.u32;
      default = null;
      defaultText = lib.literalMD ''
        Lima built-in default: same as the host user id of the current user (NOT a lookup of the specified "username").
      '';
      description = ''
        Numeric user id. It is not currently possible to specify a group id.
      '';
    };
    home = mkOption {
      type = nullOr str;
      default = null;
      defaultText = lib.literalMD ''
        Lima built-in default: "/home/{{.User}}.linux"
      '';
      description = ''
        Home directory inside the VM, NOT the mounted home directory of the host.

        It can use the following template variables:
        - Hostname
        - Name
        - Param.Key
        - UID
        - User
      '';
    };
    shell = mkOption {
      type = nullOr str;
      default = null;
      defaultText = lib.literalMD ''
        Lima built-in default: "/bin/bash"
      '';
      description = ''
        Shell. Needs to be an absolute path.
      '';
    };
  };
}
