{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkOption types;
  nixpkgsConfig = config.nixpkgs.config;
in
{
  options = with types; {
    nixpkgs = mkOption {
      default = { };
      type = submodule {
        freeformType = lazyAttrsOf raw;
        options = {
          config = mkOption {
            default = { };
            type = submodule {
              freeformType = lazyAttrsOf raw;
              options = {
                allowUnfreePackages = lib.mkOption {
                  type = with lib.types; listOf str;
                  default = [ ];
                  description = ''
                    Allows specific unfree packages to be used.

                    This option composes with `nixpkgs.config.allowUnfreePredicate` by also allowing the listed package names.

                    Unlike `nixpkgs.config.allowUnfreePredicate`, this option merges additively, similar to `environment.systemPackages`.
                    This enables defining allowed unfree packages in multiple modules, close to where they are used.

                    This avoids the need to centralize all unfree package declarations or globally enable unfree packages via
                    `nixpkgs.config.allowUnfree = true`.
                  '';
                };
              };
            };
          };
        };
      };
    };
  };

  config.flake.modules.nixos.default = {
    nixpkgs.config.allowUnfreePackages = nixpkgsConfig.allowUnfreePackages;
  };

  config.flake.modules.generic.default =
    {
      config,
      ...
    }:
    {
      # composable default based on https://github.com/NixOS/nixpkgs/blob/e32c4769fc1855a74dfd3a42c2e0d37cd795121e/pkgs/stdenv/generic/check-meta.nix#L140-L159
      nixpkgs.config.allowUnfreePredicate =
        pkg:
        builtins.elem (lib.getName pkg) (
          # NixOS compatibility + forward compatibility once nix-darwin supports a mergeable config prop
          nixpkgsConfig.allowUnfreePackages ++ (config.nixpkgs.config.allowUnfreePackages or [ ])
        );
    };
}
