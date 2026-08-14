/*
  The mkSystemWith function combines profiles, contexts and users to
  support scoping settings without managing imports manually.

  For system modules, it includes generic and class-specific modules that
  match:
  - context
  - profile
  - profile'context
  - username
  - username'context
  - username'profile

  For all users, it includes homeManager modules that match:
  - context
  - profile
  - profile'context

  For each user, it includes homeManager modules that match:
  - username
  - username'context
  - username'profile

  The single quote is a valid character for nix identifiers,
  unlike the at-symbol (@), so those names don't need quoting (See
  https://nix.dev/manual/nix/2.18/language/values#attribute-set). It
  represents the prime symbol from math, and acts akin to it, helping define
  variants/"primed" versions in a certain context/profile.

  For instance, consider a setup with:
  {
    configurations.nixos.foo = {
      contexts = [ "contoso" ];
      profiles = [ "coding" ];
      users.wally = [ ];
    };
  }

  `mkSystemWith "nixos" ...` looks up and import these modules at system level,
  if they exist:
  - flake.modules.generic.contoso
  - flake.modules.generic.coding
  - flake.modules.generic.coding'contoso
  - flake.modules.generic.wally
  - flake.modules.generic.wally'contoso
  - flake.modules.generic.wally'coding
  - flake.modules.nixos.contoso
  - flake.modules.nixos.coding
  - flake.modules.nixos.coding'contoso
  - flake.modules.nixos.wally
  - flake.modules.nixos.wally'contoso
  - flake.modules.nixos.wally'coding

  For all users (in this case `wally` only) it looks up and import these home
  modules, if they exist:
  - flake.modules.homeManager.contoso
  - flake.modules.homeManager.coding
  - flake.modules.homeManager.coding'contoso

  For user `wally` it looks up and imports these homeManager modules, if they
  exist:
  - flake.modules.homeManager.wally
  - flake.modules.homeManager.wally'contoso
  - flake.modules.homeManager.wally'coding
*/
{
  config,
  inputs,
  lib,
  self,
  ...
}:
let
  inherit (lib) mkOption types;
  configuration.options = with types; {
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
        Set of users and modules to apply to them specifically.
      '';
    };
  };

  # getSystemModulesByNameForClass :: String -> [String] -> [AttrSet]
  getSystemModulesByNameForClass =
    class: names:
    assert
      builtins.isString class
      -> builtins.stringLength class > 0 || throw "class must be a non-empty string";
    assert builtins.isList names || throw "names must be a list";
    builtins.concatMap (
      name:
      assert
        builtins.isString name -> builtins.stringLength name > 0 || throw "name must be a non-empty string";
      builtins.catAttrs name [
        config.flake.modules.generic
        config.flake.modules.${class}
        (if builtins.hasAttr "${class}Modules" self then self."${class}Modules" else { })
      ]
    ) names;
  # getHomeModulesByName :: [String] -> [AttrSet]
  getHomeModulesByName = builtins.concatMap (
    name:
    assert
      builtins.isString name -> builtins.stringLength name > 0 || throw "name must be a non-empty string";
    builtins.catAttrs name [
      config.flake.modules.homeManager
    ]
  );
  # systemSubmoduleForClass :: String -> [AttrSet]
  systemSubmoduleForClass =
    class:
    assert
      builtins.isString class
      -> builtins.stringLength class > 0 || throw "class must be a non-empty string";
    lib.types.submoduleWith {
      modules = [
        {
          _module.args = {
            inherit getHomeModulesByName;
            getSystemModulesByName = getSystemModulesByNameForClass class;
          };
        }
        configuration
      ];
      shorthandOnlyDefinesConfig = true;
    };
  # defaultHome is a functor-enabled attribute set with two levels: class then
  # username. It returns an absolute home path suggestion for the target user
  # in the target class system.
  defaultHome =
    let
      tryGetWithPrefix =
        prefix: self: username:
        assert builtins.isString prefix || throw "prefix must be a string";
        assert builtins.isAttrs self || throw "self must be an attribute set";
        assert
          builtins.isString username
          -> builtins.stringLength username > 0 || throw "username must be a non-empty string";
        if builtins.hasAttr username self then self.${username} else "${prefix}/${username}";
    in
    {
      darwin = {
        root = "/var/root";
        __functor = tryGetWithPrefix "/Users";
      };
      nixos = {
        root = "/root";
        __functor = tryGetWithPrefix "/home";
      };
    };
  # mkAllSystemsWith generates system configurations for the target class using
  # the provided mkSystem function.
  #
  # mkAllSystemsWith :: AttrSet -> AttrSet
  mkAllSystemsWith =
    {
      class,
      mkSystem,
    }:
    assert
      builtins.isString class
      -> builtins.stringLength class > 0 || throw "class must be a non-empty string";
    assert
      builtins.isFunction mkSystem
      || throw "systemFn must be a function that generates a system derivation";
    lib.flip lib.mapAttrs config.configurations.${class} (
      _:
      mkSystemWith {
        inherit class mkSystem;
      }
    );
  mkSystemWith =
    {
      class,
      mkSystem,
    }:
    {
      homeModules,
      module,
      systemModules,
      userModules,
    }:
    mkSystem {
      modules = builtins.concatLists [
        # common system configuration
        systemModules
        # per-user system configuration (allows setting user name, home, etc)
        (builtins.attrNames userModules |> getSystemModulesByNameForClass class)
        [
          # specific system configuration
          module
          # per-user system defaults
          {
            users.users = lib.genAttrs (builtins.attrNames userModules) (username: {
              name = lib.mkDefault username;
              home = lib.mkDefault (defaultHome.${class} username);
            });
          }
          # common home configuration
          {
            home-manager.sharedModules = homeModules;
          }
        ]
        # per-user home configuration
        (lib.flip lib.mapAttrsToList userModules (
          username: modules: { config, ... }: {
            home-manager.users.${username} = {
              imports = modules;
              home.username = config.users.users.${username}.name;
            };
          }
        ))
      ];
    };
in
{
  options.configurations = {
    darwin = lib.mkOption {
      description = ''
        Darwin host module configuration. Provides methods to get system and home
        modules.
      '';
      type = with lib.types; lazyAttrsOf (systemSubmoduleForClass "darwin");
    };
    nixos = lib.mkOption {
      description = ''
        NixOS host module configuration. Provides methods to get system and home
        modules.
      '';
      type = with lib.types; lazyAttrsOf (systemSubmoduleForClass "nixos");
    };
  };

  config.flake = {
    darwinConfigurations = mkAllSystemsWith {
      class = "darwin";
      mkSystem = inputs.nix-darwin.lib.darwinSystem;
    };
    nixosConfigurations = mkAllSystemsWith {
      class = "nixos";
      mkSystem = inputs.nixpkgs.lib.nixosSystem;
    };
  };
}
