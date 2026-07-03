{
  inputs,
  ...
}:
{
  flake-file.inputs.files = {
    url = "github:mightyiam/files";
    flake = false;
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
