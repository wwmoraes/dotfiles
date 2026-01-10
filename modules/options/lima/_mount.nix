{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkOption types;
in
{
  options = with types; {
    location = mkOption {
      type = str;
      description = ''
        Host path to mount into the guest.

        Supports go template. Available variables in the root context:
        - Home
        - Dir
        - Name
        - UID
        - User
        - Param.Key
        - GlobalTempDir
        - TempDir

        The global temp dir is always "/tmp" on Unix.
      '';
    };
    mountPoint = mkOption {
      type = str;
      default = config.location;
      description = ''
        Configure the mount point inside the guest.
      '';
    };
    writable = mkOption {
      type = bool;
      default = false;
      description = ''
        Enables guest writing to the mount point.

        Setting it to true is discouraged when the mount type is "reverse-sshfs".
      '';
    };
    sshfs = mkOption {
      type = submodule ./_sshfs.nix;
      apply = lib.filterAttrsRecursive (_: v: v != null);
      default = { };
    };
    "9p" = mkOption {
      type = submodule ./_9p.nix;
      apply = lib.filterAttrsRecursive (_: v: v != null);
      default = { };
    };
  };
}
