{
  flake.modules.generic.default =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = [
        # keep-sorted start
        pkgs.coreutils
        # pkgs.envsubst
        pkgs.fd
        pkgs.moreutils
        pkgs.ripgrep
        pkgs.tlrc
        # keep-sorted end
      ];
    };
}
