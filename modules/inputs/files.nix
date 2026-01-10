{
  inputs,
  ...
}:
{
  flake-file.inputs.files.url = "github:mightyiam/files";

  imports = [
    inputs.files.flakeModules.default
  ];

  flake.overlays.files = final: prev: {
    lib = prev.lib.extend (
      _: lib: {
        local = lib.local.extend (
          final: prev: {
            wrapText =
              {
                prefix ? "", # line comment prefix; also applies on block to indent lines
                start ? "", # block comment start
                end ? "", # block comment end
                text,
              }:
              let
                lines = builtins.filter builtins.isString (builtins.split "\n" text);
                prepend = prefix: lines: map (line: "${prefix}${line}") lines;
                optional = str: lib.optional (str != "") str;
              in
              builtins.concatStringsSep "\n" ((optional start) ++ (prepend prefix lines) ++ (optional end));
          }
        );
      }
    );
  };

  perSystem =
    { config, ... }:
    {
      apps.${config.files.writer.exeFilename} = {
        type = "app";
        program = config.files.writer.drv;
      };
    };
}
