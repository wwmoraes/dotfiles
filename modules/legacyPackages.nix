{
  self,
  ...
}:
{
  perSystem =
    {
      pkgs,
      ...
    }:
    {
      # Adds one package per NixOS configuration to reflect their
      # configuration as a VM image. Uses legacyPackages for the very reason
      # it exists: to defer its evaluation as the packages property is
      # always evaluated by flakes.
      legacyPackages =
        pkgs.lib.mapAttrs'
          (name: value: {
            name = "${name}-image";
            value = value.config.system.build.images.qemu-efi;
          })
          (
            pkgs.lib.filterAttrs (
              k: v: v.config.nixpkgs.hostPlatform.system == pkgs.stdenv.hostPlatform.system
            ) self.nixosConfigurations
          );
    };
}
