{
  lib,
  ...
}:
{
  programs.gh = {
    hosts = {
      "github.com" = {
        users = [
          "wwmoraes"
        ];
        user = lib.mkDefault "wwmoraes";
      };
    };
  };
}
