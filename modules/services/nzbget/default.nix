{
  flake.modules.nixos.media-server =
    {
      pkgs,
      ...
    }:
    {
      containers.nzbget = {
        autoStart = true;
        # TODO review IFD and factor it out if possible
        config = import ./_configuration.nix;
        nixpkgs = pkgs.path;
        privateNetwork = true;
        privateUsers = "pick";
        bindMounts = {
          "/var/lib/nzbget" = {
            hostPath = "/var/lib/nzbget";
            isReadOnly = false;
          };
        };
        forwardPorts = [
          {
            protocol = "tcp";
            hostPort = 6791;
            containerPort = 6791;
          }
        ];
      };
    };
}
