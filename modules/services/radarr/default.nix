{
  flake.modules.nixos.media-server =
    {
      pkgs,
      ...
    }:
    {
      containers.radarr = {
        autoStart = true;
        # TODO review IFD and factor it out if possible
        config = import ./_configuration.nix;
        nixpkgs = pkgs.path;
        privateNetwork = true;
        privateUsers = "pick";
        bindMounts = {
          "/var/lib/radarr" = {
            hostPath = "/var/lib/radarr";
            isReadOnly = false;
          };
        };
        forwardPorts = [
          {
            protocol = "tcp";
            hostPort = 7878;
            containerPort = 7878;
          }
        ];
      };
    };
}
