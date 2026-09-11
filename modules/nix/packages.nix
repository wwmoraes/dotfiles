{
  lib,
  ...
}:
{
  flake.modules.generic.default =
    {
      config,
      pkgs,
      ...
    }:
    {
      environment.systemPackages = [
        # keep-sorted start
        pkgs.git
        pkgs.nix-index
        pkgs.nix-init
        pkgs.nixos-rebuild
        pkgs.nurl
        # keep-sorted end
      ];

      home-manager.sharedModules = [
        {
          nix.package = lib.mkDefault config.nix.package;
          programs.helix.extraPackages = lib.mkMerge [
            [
              pkgs.unstable.nil
              pkgs.unstable.nixd
            ]
          ];
        }
      ];

      nix.package = pkgs.nixVersions.latest;
    };
}
