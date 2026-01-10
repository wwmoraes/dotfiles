{
  flake.modules.darwin.personal = {
    homebrew.casks = [
      "macfuse" # # needed by resilio-sync
      "resilio-sync"
    ];
  };

  flake.modules.nixos.nas =
    {
      pkgs,
      ...
    }:
    {
      containers.resilio = {
        autoStart = true;
        # TODO review IFD and factor it out if possible
        config = import ./_configuration.nix;
        nixpkgs = pkgs.path;
        privateNetwork = true;
        privateUsers = "pick";
        bindMounts = {
          "/srv/resilio" = {
            hostPath = "/srv/resilio";
            isReadOnly = false;
          };
          "/var/lib/resilio" = {
            hostPath = "/var/lib/resilio";
            isReadOnly = false;
          };
        };
        forwardPorts = [
          {
            protocol = "tcp";
            hostPort = 9000;
            containerPort = 9000;
          }
        ];
      };
    };
}
