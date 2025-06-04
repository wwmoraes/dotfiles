{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.packages = lib.optionals config.programs.docker.enable [
    pkgs.dive
  ];

  home.sessionVariables = lib.mkIf config.programs.docker.enable {
    DOCKER_HOST = "unix://${config.home.homeDirectory}/.docker/run/docker.sock";
  };

  programs.docker = {
    enable = true;
    settings = {
      auths = {
        "https://index.docker.io/v1/" = { };
      };
      aliases = {
        builder = "buildx";
      };
      credsStore = "osxkeychain";
      currentContext = "desktop-linux";
      experimental = "disabled";
      features = {
        hooks = "false";
      };
      plugins = {
        "-x-cli-hints".enabled = "false";
        "debug".hooks = "exec";
        "scout".hooks = "pull,buildx build";
      };
    };
  };

  programs.helix.extraPackages = lib.optionals config.programs.docker.enable [
    pkgs.unstable.docker-compose-language-service
    pkgs.unstable.dockerfile-language-server-nodejs
  ];
}
