{
  lib,
  ...
}:
let
  inherit (lib) mkOption types;
in
{
  options = with types; {
    mode = mkOption {
      type = enum [
        "readiness"
      ];
      default = "readiness";
      description = ''
        Type of probe. "readiness" checks for the ready state of the VM. This
        often includes asserting whether packages, files or configurations are
        present.
      '';
    };
    description = mkOption {
      type = nullOr str;
      default = null;
      description = ''
        User-friendly description of what this probe is about.
      '';
    };
    script = mkOption {
      type = nullOr str;
      default = null;
      description = ''
        Script to run in user mode. It must start with a hashbang line.

        Scripts can use the following template variables:
        - Home
        - Hostname
        - Name
        - Param.Key
        - UID
        - User
      '';
    };
    hint = mkOption {
      type = nullOr str;
      default = null;
      description = ''
        Message to output to the user in case the probe fails.
      '';
    };
    file = mkOption {
      type = nullOr (either str (submodule ./_file.nix));
      default = null;
      description = ''
        EXPERIMENTAL. Alternative to the script property. This file is read when
        the instance is created and then stored under the "script" property.
        When "file" is specified "script" must be empty.
      '';
    };
  };
}
