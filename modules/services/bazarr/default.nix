{
  flake.modules.nixos.media-server =
    {
      pkgs,
      ...
    }:
    {
      containers.bazarr = {
        autoStart = true;
        # TODO review IFD and factor it out if possible
        config = import ./_configuration.nix;
        nixpkgs = pkgs.path;
        privateNetwork = true;
        privateUsers = "pick";
        bindMounts = {
          "/var/lib/bazarr" = {
            hostPath = "/var/lib/bazarr";
            isReadOnly = false;
          };
        };
        forwardPorts = [
          {
            protocol = "tcp";
            hostPort = 6767;
            containerPort = 6767;
          }
        ];
      };
    };
}
