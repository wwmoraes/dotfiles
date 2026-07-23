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
  ...
}:
let
  configuration.options = with lib.types; {
    module = lib.mkOption {
      type = deferredModule;
      description = ''
        A lazy module with settings to add to the system when creating it.
        This can contain any configuration documented by the target class
        (nixos/darwin).
      '';
    };
    systemModules = lib.mkOption {
      type = listOf deferredModule;
      default = [ ];
      description = ''
        Extra modules to apply to the system. This is a convenience shortcut
        equivalent to adding these same modules to `module.imports`.
      '';
    };
    homeModules = lib.mkOption {
      type = listOf deferredModule;
      default = [ ];
      description = ''
        Common home-manager modules applied to all managed users. This
        is a convenience shortcut equivalent to adding these same modules to
        `home-manager.sharedModules` inside a `module.imports`.
      '';
    };
    users = lib.mkOption {
      type = attrsOf (listOf deferredModule);
      default = { };
      description = ''
        Set of users and modules to apply to them specifically.
      '';
    };
    profiles = lib.mkOption {
      type = listOf str;
      default = [ ];
      description = ''
        Set of terms to match flake modules to apply. It's used for generic,
        system-specific and user modules.
      '';
    };
    contexts = lib.mkOption {
      type = listOf str;
      default = [ ];
      description = ''
        Set of terms to match flake modules to apply. It's used for generic,
        system-specific and user modules.
      '';
    };
  };

  # getNamedModules :: [a :: str] -> [b :: AttrSet str module] -> [c :: module]
  getNamedModules = tags: attrsList: (lib.flatten (lib.map (tag: lib.catAttrs tag attrsList) tags));
  # gengenPrimedProductStrings :: [a :: str] -> [b :: str] -> [c :: str]
  genPrimedProductStrings =
    prefixes: suffixes:
    lib.mapCartesianProduct ({ prefix, suffix }: "${prefix}'${suffix}") {
      prefix = prefixes;
      suffix = suffixes;
    };
  mkSystemWith =
    class: systemFn:
    lib.flip lib.mapAttrs config.configurations.${class} (
      hostname:
      {
        contexts,
        homeModules,
        module,
        systemModules,
        profiles,
        users,
      }:
      let
        usernames = builtins.filter (username: (builtins.substring 0 1 username) != "_") (
          builtins.attrNames users
        );
        systemModuleNames =
          usernames
          ++ contexts
          ++ profiles
          ++ (genPrimedProductStrings profiles contexts)
          ++ (genPrimedProductStrings usernames contexts)
          ++ (genPrimedProductStrings usernames profiles);
        shareHomeModuleNames = contexts ++ profiles ++ (genPrimedProductStrings profiles contexts);
        perUserModuleNames = lib.genAttrs usernames (
          username:
          [ username ]
          ++ (genPrimedProductStrings [ username ] contexts)
          ++ (genPrimedProductStrings [ username ] profiles)
        );
      in
      systemFn {
        modules =
          systemModules
          ++ [
            module
            {
              home-manager.sharedModules =
                homeModules
                ++ (getNamedModules shareHomeModuleNames [
                  config.flake.modules.homeManager
                ]);
            }
          ]
          ++ (lib.mapAttrsToList (username: userModules: {
            home-manager.users.${username}.imports =
              userModules
              ++ (getNamedModules perUserModuleNames.${username} [
                config.flake.modules.homeManager
              ]);
          }) users)
          ++ (getNamedModules systemModuleNames [
            config.flake.modules.generic
            config.flake.modules.${class}
          ]);
      }
    );
in
{
  options.configurations.darwin = lib.mkOption {
    type = with lib.types; lazyAttrsOf (submodule configuration);
  };
  options.configurations.nixos = lib.mkOption {
    type = with lib.types; lazyAttrsOf (submodule configuration);
  };

  config.flake = {
    darwinConfigurations = mkSystemWith "darwin" inputs.nix-darwin.lib.darwinSystem;
    nixosConfigurations = mkSystemWith "nixos" inputs.nixpkgs.lib.nixosSystem;
  };
}
