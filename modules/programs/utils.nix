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
        # keep-sorted end
      ];
    };
}
