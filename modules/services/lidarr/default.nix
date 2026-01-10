{
  flake.modules.nixos.media-server =
    {
      pkgs,
      ...
    }:
    {
      containers.lidarr = {
        autoStart = true;
        # TODO review IFD and factor it out if possible
        config = import ./_configuration.nix;
        nixpkgs = pkgs.path;
        privateNetwork = true;
        privateUsers = "pick";
        bindMounts = {
          "/var/lib/lidarr" = {
            hostPath = "/var/lib/lidarr";
            isReadOnly = false;
          };
        };
        forwardPorts = [
          {
            protocol = "tcp";
            hostPort = 8686;
            containerPort = 8686;
          }
        ];
      };
    };
}
