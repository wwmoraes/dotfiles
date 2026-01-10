{
  lib,
  ...
}:
let
  inherit (lib) mkOption types;
in
{
  options = with types; {
    enabled = mkOption {
      type = bool;
      default = false;
      description = ''
        Enable kubernetes.
      '';
    };
    version = mkOption {
      type = nullOr str;
      default = null;
      description = ''
        Kubernetes version to use.
        This needs to exactly match a k3s version https://github.com/k3s-io/k3s/releases

        Default: latest stable release
      '';
    };
    k3sArgs = mkOption {
      type = listOf str;
      default = [ ];
      description = ''
        Additional args to pass to k3s https://docs.k3s.io/cli/server

        Default: traefik is disabled
      '';
    };
  };
}
