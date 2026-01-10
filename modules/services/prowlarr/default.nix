{
  flake.modules.nixos.media-server =
    {
      pkgs,
      ...
    }:
    {
      containers.prowlarr = {
        autoStart = true;
        # TODO review IFD and factor it out if possible
        config = import ./_configuration.nix;
        nixpkgs = pkgs.path;
        privateNetwork = true;
        privateUsers = "pick";
        bindMounts = {
          "/var/lib/prowlarr" = {
            hostPath = "/var/lib/prowlarr";
            isReadOnly = false;
          };
        };
        forwardPorts = [
          {
            protocol = "tcp";
            hostPort = 9696;
            containerPort = 9696;
          }
        ];
      };
    };
}
