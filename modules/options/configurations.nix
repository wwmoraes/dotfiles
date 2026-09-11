{
  config,
  inputs,
  lib,
  self,
  ...
}:
let
  inherit (lib) mkOption types;
  host.options = with types; {
    homeModules = mkOption {
      type = listOf deferredModule;
      default = [ ];
      description = ''
        Common home-manager modules applied to all managed users. This
        is a convenience shortcut equivalent to adding these same modules to
        `home-manager.sharedModules` inside a `module.imports`.
      '';
    };
    module = mkOption {
      type = nullOr deferredModule;
      default = null;
      description = ''
        A lazy module with settings to add to the system when creating it.
        This can contain any configuration documented by the target system class
        (nixos/darwin).
      '';
    };
    systemModules = mkOption {
      type = listOf deferredModule;
      default = [ ];
      description = ''
        Extra modules to apply to the system. This is a convenience shortcut
        equivalent to adding these same modules to `module.imports`.
      '';
    };
    userModules = mkOption {
      type = attrsOf (listOf deferredModule);
      default = { };
      description = ''
        Set of users and home modules to apply to them specifically.
      '';
    };
  };

  # transforms a host attribute set into an acceptable parameter for a system
  # configuration function e.g nixosSystem/darwinSystem.
  mkSystemAttrsFromHostConfig =
    {
      homeModules ? [ ],
      module ? null,
      systemModules ? [ ],
      userModules ? { },
    }:
    {
      modules = builtins.concatLists [
        # common system configuration
        systemModules
        [
          # specific system configuration
          module
          # common home configuration
          {
            home-manager.sharedModules = homeModules;
          }
        ]
        # per-user home configuration
        (lib.flip lib.mapAttrsToList userModules (
          username: modules: {
            home-manager.users.${username} = {
              imports = modules;
            };
          }
        ))
      ];
    };
in
{
  options.hosts =
    let
      systemSubmodule =
        {
          systemModules ? [ ],
          homeModules ? { },
        }:
        lib.types.submoduleWith {
          modules = [
            {
              _module.args = {
                # getHomeModulesByName :: [String] -> [AttrSet]
                getHomeModulesByName = builtins.concatMap (lib.flip builtins.catAttrs (lib.toList homeModules));
                # getSystemModulesByName :: [String] -> [AttrSet]
                getSystemModulesByName = builtins.concatMap (lib.flip builtins.catAttrs (lib.toList systemModules));
              };
            }
            host
          ];
          shorthandOnlyDefinesConfig = true;
        };
    in
    {
      darwin = lib.mkOption {
        description = ''
          Darwin host module configuration.

          Provides two functions to retrieve modules by their names if they
          exist:

          - getHomeModulesByName retrieves home modules
          - getSystemModulesByName retrieves generic and class system modules
        '';
        type =
          with lib.types;
          lazyAttrsOf (systemSubmodule {
            systemModules = [
              config.flake.modules.generic
              config.flake.modules.darwin
              self.darwinModules
            ];
            homeModules = config.flake.modules.homeManager;
          });
      };
      nixos = lib.mkOption {
        description = ''
          NixOS host module configuration.

          Provides two functions to retrieve modules by their names if they
          exist:

          - getHomeModulesByName retrieves home modules
          - getSystemModulesByName retrieves generic and class system modules
        '';
        type =
          with lib.types;
          lazyAttrsOf (systemSubmodule {
            systemModules = [
              config.flake.modules.generic
              config.flake.modules.nixos
              self.nixosModules
            ];
            homeModules = config.flake.modules.homeManager;
          });
      };
    };

  config.flake = {
    darwinConfigurations = lib.mapAttrs (
      _: hostConfig: inputs.nix-darwin.lib.darwinSystem (mkSystemAttrsFromHostConfig hostConfig)
    ) config.hosts.darwin;
    nixosConfigurations = lib.mapAttrs (
      _: hostConfig: inputs.nixpkgs.lib.nixosSystem (mkSystemAttrsFromHostConfig hostConfig)
    ) config.hosts.nixos;
  };
}
