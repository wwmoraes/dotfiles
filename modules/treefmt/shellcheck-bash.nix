{ lib, mkFormatterModule, ... }:
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
  ];
}
