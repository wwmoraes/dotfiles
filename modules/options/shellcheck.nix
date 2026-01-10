{
  flake.modules.treefmt.shellcheck =
    {
      lib,
      mkFormatterModule,
      ...
    }:
    {
      meta.maintainers = [
        lib.maintainers.wwmoraes or "wwmoraes"
      ];

      imports = [
        (mkFormatterModule {
          name = "shellcheck-bash";
          package = "shellcheck";
          args = [ "--shell=bash" ];
          includes = [
            "*.bash"
            # direnv
            "*.envrc"
            "*.envrc.*"
          ];
        })
        (mkFormatterModule {
          name = "shellcheck-posix";
          package = "shellcheck";
          args = [ "--shell=sh" ];
          includes = [
            "*.sh"
          ];
        })
      ];
    };
}
