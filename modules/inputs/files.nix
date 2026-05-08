{
  inputs,
  ...
}:
{
  flake-file.inputs.files.url = "github:mightyiam/files";

  imports = [
    inputs.files.flakeModules.default
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
