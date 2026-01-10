{
  lib,
  ...
}:
let
  inherit (lib) mkOption types;
in
{
  options = with types; {
    localPort = mkOption {
      type = nullOr port;
      default = null;
      defaultText = lib.literalMD ''
        Lima built-in default: 0 (automatically assigned to a free port)
      '';
      description = ''
        A localhost port of the host. Forwarded to port 22 of the guest.
      '';
    };
    loadDotSSHPubKeys = mkOption {
      type = bool;
      default = false;
      description = ''
        Load ~/.ssh/*.pub in addition to $LIMA_HOME/_config/user.pub .
        This option is useful when you want to use other SSH-based
        applications such as rsync with the Lima instance.
        If you have an insecure key under ~/.ssh, do not use this option.
      '';
    };

    forwardAgent = mkOption {
      type = bool;
      default = false;
      description = ''
        Forward ssh agent into the instance. The ssh agent socket can be mounted
        in a container at the path `/run/host-services/ssh-auth.sock`. Set the
        environment variable `SSH_AUTH_SOCK` value to the path above. The socket
        is accessible by the non-root user inside the Lima instance.
      '';
    };

    forwardX11 = mkOption {
      type = bool;
      default = false;
      description = ''
        Forward X11 into the instance.
      '';
    };

    forwardX11Trusted = mkOption {
      type = bool;
      default = false;
      description = ''
        Trust forwarded X11 clients.
      '';
    };

    overVsock = mkOption {
      type = nullOr bool;
      default = null;
      defaultText = lib.literalMD ''
        Lima built-in default: true for vz, false for other vmTypes
      '';
      description = ''
        Enable SSH over vsock.
      '';
    };
  };
}
