{
  lib,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    types
    ;
in
{

  flake.modules.homeManager.default =
    {
      config,
      pkgs,
      ...
    }:
    let
      cfg = config.programs.docker;
    in
    {
      meta.maintainers = [
        lib.maintainers.wwmoraes or "wwmoraes"
      ];

      options = {
        programs.docker = {
          enable = mkEnableOption "Docker client to run containerized applications";

          package = mkPackageOption pkgs "docker-client" {
            nullable = true;
            default = "docker-client";
          };

          # enableBashIntegration = lib.hm.shell.mkBashIntegrationOption { inherit config; };
          # enableFishIntegration = lib.hm.shell.mkFishIntegrationOption { inherit config; };
          # enableZshIntegration = lib.hm.shell.mkZshIntegrationOption { inherit config; };

          settings = mkOption {
            default = { };
            type = with types; attrsOf anything;
            description = ''
              Client configuration settings.
              Options described in
              <https://docs.docker.com/reference/cli/docker/#docker-cli-configuration-file-configjson-properties>.
            '';
            example = lib.literalExpression ''
              {
                HttpHeaders = {
                  MyHeader = "MyValue";
                };
                psFormat = "table {{.ID}}\\t{{.Image}}\\t{{.Command}}\\t{{.Labels}}";
                imagesFormat = "table {{.ID}}\\t{{.Repository}}\\t{{.Tag}}\\t{{.CreatedAt}}";
                pluginsFormat = "table {{.ID}}\t{{.Name}}\t{{.Enabled}}";
                statsFormat = "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}";
                servicesFormat = "table {{.ID}}\t{{.Name}}\t{{.Mode}}";
                secretFormat = "table {{.ID}}\t{{.Name}}\t{{.CreatedAt}}\t{{.UpdatedAt}}";
                configFormat = "table {{.ID}}\t{{.Name}}\t{{.CreatedAt}}\t{{.UpdatedAt}}";
                serviceInspectFormat = "pretty";
                nodesFormat = "table {{.ID}}\t{{.Hostname}}\t{{.Availability}}";
                detachKeys = "ctrl-e,e";
                credsStore = "secretservice";
                credHelpers = {
                  "awesomereg.example.org": "hip-star";
                  "unicorn.example.com": "vcbait";
                };
                plugins = {
                  plugin1 = {
                    option = "value";
                  };
                  plugin2 = {
                    anotheroption = "anothervalue";
                    athirdoption = "athirdvalue";
                  };
                };
                proxies = {
                  default = {
                    httpProxy = "http://user:pass@example.com:3128";
                    httpsProxy = "https://my-proxy.example.com:3129";
                    noProxy = "intra.mycorp.example.com";
                    ftpProxy = "http://user:pass@example.com:3128";
                    allProxy = "socks://example.com:1234";
                  };
                  "https://manager1.mycorp.example.com:2377" = {
                    httpProxy = "http://user:pass@example.com:3128";
                    httpsProxy = "https://my-proxy.example.com:3129";
                  };
                };
              };
            '';
          };
        };

      };

      ## TODO converge docker settings with NixOS options
      ## see https://search.nixos.org/options?channel=25.05&show=virtualisation.docker.daemon.settings&from=0&size=50&sort=relevance&type=packages&query=virtualisation.docker
      config = mkIf cfg.enable {
        home.packages = [
          cfg.package
          pkgs.docker-credential-helpers
        ];

        home.file.".docker/config.json".text = lib.generators.toJSON { } cfg.settings;
      };
    };
}
