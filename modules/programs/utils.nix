{
  flake.modules.generic.shell'personal =
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
