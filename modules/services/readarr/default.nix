{
  flake.modules.nixos.media-server =
    {
      pkgs,
      ...
    }:
    {
      containers.readarr = {
        autoStart = true;
        # TODO review IFD and factor it out if possible
        config = import ./_configuration.nix;
        nixpkgs = pkgs.path;
        privateNetwork = true;
        privateUsers = "pick";
        bindMounts = {
          "/var/lib/readarr" = {
            hostPath = "/var/lib/readarr";
            isReadOnly = false;
          };
        };
        forwardPorts = [
          {
            protocol = "tcp";
            hostPort = 8787;
            containerPort = 8787;
          }
        ];
      };
    };
}
