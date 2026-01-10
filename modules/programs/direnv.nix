{
  flake.modules.generic.shell = {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      silent = true;
      settings.global = {
        hide_env_diff = true;
        load_dotenv = true;
        strict_env = true;
      };
    };
  };

  flake.modules.homeManager.shell =
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

      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
        silent = true;
        config.global = {
          hide_env_diff = true;
          load_dotenv = true;
          strict_env = true;
        };
      };

      programs.fish.interactiveShellInit = lib.mkIf config.programs.direnv.enable (
        lib.mkMerge [
          (lib.mkBefore ''
            # force a clean environment on load
            eval (pushd /; ${lib.getExe config.programs.direnv.package} export fish; popd)
          '')
        ]
      );
    };
}
