{
  lib,
  ...
}:
let
  inherit (lib) mkOption types;
in
{
  options = with types; {
    address = mkOption {
      type = bool;
      default = false;
      description = ''
        Assign reachable IP address to the virtual machine.

        NOTE: this is currently macOS only and ignored on Linux.
      '';
    };
    dns = mkOption {
      type = listOf str;
      default = [ ];
      description = ''
        Custom DNS resolvers for the virtual machine.
      '';
    };
    dnsHosts = mkOption {
      type = attrsOf str;
      default = {
        "host.docker.internal" = "host.lima.internal";
      };
      description = ''
        DNS hostnames to resolve to custom targets using the internal resolver.
        This setting has no effect if a custom DNS resolver list is supplied above.
        It does not configure the /etc/hosts files of any machine or container.
        The value can be an IP address or another host.
      '';
    };
    hostAddresses = mkOption {
      type = bool;
      default = false;
      description = ''
        Replicate host IP addresses in the VM. This enables port forwarding to specific
        host IP addresses.
          e.g. `docker run --port 10.0.1.2:8080:8080 alpine` would only forward to the
          specified IP address.
      '';
    };
  };
}
