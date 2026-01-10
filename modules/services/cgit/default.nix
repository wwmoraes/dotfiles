{
  flake.modules.nixos.__nas =
    {
      pkgs,
      ...
    }:
    {
      containers.cgit = {
        autoStart = true;
        # TODO review IFD and factor it out if possible
        config = import ./_configuration.nix;
        nixpkgs = pkgs.path;
        privateNetwork = true;
        privateUsers = "pick";
        bindMounts = {
          "/srv/git" = {
            hostPath = "/srv/git";
            isReadOnly = false;
          };
        };
      };
    };
}
