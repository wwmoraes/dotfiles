{
  inputs,
  self,
  ...
}:
{
  _module.args.rootPath = self + /.;

  flake-file.inputs.flake-parts.url = "github:hercules-ci/flake-parts";

  imports = [
    inputs.flake-parts.flakeModules.modules
  ];
}
