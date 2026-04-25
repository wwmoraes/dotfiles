{
  inputs,
  self,
  ...
}:
{
  _module.args.rootPath = self + /.;

  flake-file = {
    inputs.flake-parts.url = "github:hercules-ci/flake-parts";
    nixConfig = {
      extra-substituters = [
        "https://hercules-ci.cachix.org/"
      ];
      extra-trusted-public-keys = [
        "hercules-ci.cachix.org-1:ZZeDl9Va+xe9j+KqdzoBZMFJHVQ42Uu/c/1/KMC5Lw0="
      ];
    };
  };

  imports = [
    inputs.flake-parts.flakeModules.modules
  ];
}
