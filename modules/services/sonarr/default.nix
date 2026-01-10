{
  flake.modules.nixos.media-server =
    {
      pkgs,
      ...
    }:
    {
      containers.sonarr = {
        autoStart = true;
        # TODO review IFD and factor it out if possible
        config = import ./_configuration.nix;
        nixpkgs = pkgs.path;
        privateNetwork = true;
        privateUsers = "pick";
        bindMounts = {
          "/var/lib/sonarr" = {
            hostPath = "/var/lib/sonarr";
            isReadOnly = false;
          };
        };
        forwardPorts = [
          {
            protocol = "tcp";
            hostPort = 8989;
            containerPort = 8989;
          }
        ];
      };
    };
}
