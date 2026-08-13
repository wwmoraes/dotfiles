{
  inputs,
  ...
}:
{
  flake-file.inputs.files = {
    flake = false;
    inputs.flake-parts.follows = "flake-parts";
    inputs.import-tree.follows = "import-tree";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.systems.follows = "systems";
    inputs.treefmt-nix.follows = "treefmt-nix";
    url = "github:mightyiam/files";
  };

  imports = [
    (inputs.files + "/flake-module.nix")
  ];

  perSystem =
    { config, ... }:
    {
      apps.${config.files.writer.exeFilename} = {
        type = "app";
        program = config.files.writer.drv;
      };
    };
}
