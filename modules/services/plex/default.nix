{
  flake.modules.darwin.personal = {
    homebrew.casks = [
      "plex-htpc"
      "plexamp"
    ];
  };

  flake.modules.nixos.media-server =
    {
      pkgs,
      ...
    }:
    {
      containers.plex = {
        autoStart = true;
        # TODO review IFD and factor it out if possible
        config = import ./_configuration.nix;
        nixpkgs = pkgs.path;
        privateNetwork = true;
        privateUsers = "pick";
        bindMounts = {
          "/var/lib/plex" = {
            hostPath = "/var/lib/plex";
            isReadOnly = false;
          };
        };
        forwardPorts =
          (map
            (port: {
              protocol = "tcp";
              hostPort = port;
              containerPort = port;
            })
            [
              32400
              3005
              8324
              32469
            ]
          )
          ++ (map
            (port: {
              protocol = "udp";
              hostPort = port;
              containerPort = port;
            })
            [
              1900
              5353
              32410
              32412
              32413
              32414
            ]
          );
      };
    };
}
