{
  inputs,
  ...
}:
{
  flake-file.inputs.flake-file.url = "github:vic/flake-file";

  flake-file.description = "wwmoraes' dotfiles on steroids";

  imports = [
    inputs.flake-file.flakeModules.dendritic
  ];
}
