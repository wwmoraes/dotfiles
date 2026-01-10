{
  lib,
  ...
}:
let
  inherit (lib) mkOption types;
in
{
  options = with types; {
    cache = mkOption {
      type = bool;
      default = true;
      description = ''
        Enabling the SSHFS cache will increase performance of the mounted
        filesystem, at the cost of potentially not reflecting changes made
        on the host in a timely manner. Warning: It looks like PHP filesystem
        access does not work correctly when the cache is disabled.
      '';
    };
    followSymlinks = mkOption {
      type = bool;
      default = false;
      description = ''
        SSHFS has an optional flag called 'follow_symlinks'. This allows mounts
        to be properly resolved in the guest os and allow for access to the
        contents of the symlink. As a result, symlinked files & folders on the
        Host system will look and feel like regular files directories in the
        Guest OS.
      '';
    };
    sftpDriver = mkOption {
      type = nullOr (enum [
        "builtin"
        "openssh-sftp-server"
      ]);
      default = null;
      defaultText = lib.literalMD ''
        Lima built-in default: "openssh-sftp-server" if OpenSSH SFTP Server binary is found, otherwise "builtin"
      '';
      description = ''
        SFTP driver. "openssh-sftp-server" is recommended.
      '';
    };
  };
}
