{
  lib,
  ...
}:
{
  options.flake.darwinModules = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.raw;
    default = { };
    description = ''
      Darwin Modules

      You may use this for reusable pieces of configuration, service modules, etc.
    '';
  };
}
