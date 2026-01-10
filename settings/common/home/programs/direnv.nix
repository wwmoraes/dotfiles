{
  config,
  lib,
  ...
}:
{
  editorconfig.settings.".direnv/*" = {
    charset = "unset";
    indent_size = "unset";
    indent_style = "unset";
    insert_final_newline = "unset";
    tab_width = "unset";
    trim_trailing_whitespace = "unset";
  };

  programs.fish.interactiveShellInit = lib.mkIf config.programs.direnv.enable (
    lib.mkMerge [
      (lib.mkBefore ''
        # force a clean environment on load
        eval (pushd /; ${lib.getExe config.programs.direnv.package} export fish; popd)
      '')
    ]
  );

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    silent = true;
  };
}
