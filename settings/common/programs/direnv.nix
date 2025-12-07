{
  pkgs,
  ...
}:
{
  environment.etc."direnv/direnv.toml" = {
    enable = true;
    source = (pkgs.formats.toml { }).generate "direnv.toml" {
      global = {
        hide_env_diff = true;
        load_dotenv = true;
        strict_env = true;
      };
    };
  };
}
