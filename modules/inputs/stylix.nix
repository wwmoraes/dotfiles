{
  inputs,
  lib,
  ...
}:
{
  flake-file.inputs.stylix = {
    inputs.flake-parts.follows = "flake-parts";
    inputs.gnome-shell.follows = "gnome-shell";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.nur.follows = "nur";
    inputs.systems.follows = "systems";
    url = "github:danth/stylix/release-25.11";
  };

  flake.modules.generic.default = {
    home-manager.sharedModules = [
      inputs.stylix.homeModules.stylix
      {
        stylix = {
          # overlays do not work with home-manager.useGlobalPkgs
          overlays.enable = false;
          # disable unused programs to avoid unnecessary builds
          targets =
            lib.genAttrs
              [
                # keep-sorted start
                "gnome"
                "gnome-text-editor"
                "gtk"
                # keep-sorted end
              ]
              (_: {
                enable = lib.mkDefault false;
              });
        };
      }
    ];
  };

  flake.modules.nixos.default = {
    imports = [
      inputs.stylix.nixosModules.stylix
    ];
  };

  flake.modules.darwin.default = {
    imports = [
      inputs.stylix.darwinModules.stylix
    ];
  };
}
