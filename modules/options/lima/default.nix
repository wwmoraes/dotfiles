{
  flake.modules.homeManager.default =
    {
      config,
      pkgs,
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

      cfg = config.services.lima;
      yaml = pkgs.formats.yaml { };
    in
    {
      meta.maintainers = [
        lib.maintainers.wwmoraes or "wwmoraes"
      ];

      options.services.lima = with types; {
        enable = mkEnableOption "Linux virtual machines with automatic file sharing and port forwarding";

        baseConfig = mkOption {
          type = submodule ./_template.nix;
          apply = lib.filterAttrsRecursive (_: v: v != null);
          default = { };
        };

        defaults = mkOption {
          type = submodule ./_template.nix;
          apply = lib.filterAttrsRecursive (_: v: v != null);
          default = { };
        };

        instances = mkOption {
          type = attrsOf anything;
          apply = lib.filterAttrsRecursive (_: v: v != null);
          default = { };
        };

        overrides = mkOption {
          type = submodule ./_template.nix;
          apply = lib.filterAttrsRecursive (_: v: v != null);
          default = { };
        };

        package = mkPackageOption pkgs "lima" {
          default = [ "lima" ];
        };

        templates = mkOption {
          type = attrsOf (submodule ./_template.nix);
          apply = lib.filterAttrsRecursive (_: v: v != null);
          default = { };
        };
      };

      config = mkIf cfg.enable {
        home.activation.limaInstances = lib.hm.dag.entryAfter [ "writeBoundary" ] (
          lib.concatMapAttrsStringSep "\n" (name: instance: ''
            if ! limactl list --json | jq --slurp '.[] | select(.name == "${name}")' | grep -q .; then
              echo "provisioning lima ${name} instance..."
              run env PATH=${
                lib.makeBinPath [ pkgs.openssh ]
              }''${PATH:+:}$PATH limactl create --tty=false --name=${lib.escapeShellArg name} ${instance.source}
            fi
          '') cfg.instances
        );

        home.extraActivationPath = [
          cfg.package
          config.programs.jq.package
        ]
        ++ (lib.optionals pkgs.stdenv.isDarwin [
          pkgs.darwin.DarwinTools
        ]);

        home.packages = mkIf (cfg.package != null) [
          cfg.package
        ];

        home.sessionVariables = {
          LIMA_HOME = "${config.xdg.configHome}/lima";
          LIMA_TEMPLATES_PATH = "${config.xdg.configHome}/lima/_templates";
        };

        programs.docker.settings.currentContext = "lima";

        programs.ssh = {
          includes = [
            "${config.xdg.configHome}/lima/*/ssh.config"
          ];
        };

        xdg.configFile = {
          "lima/_config/base.yaml" = {
            source = yaml.generate "lima-config-base.yaml" cfg.baseConfig;
          };
          "lima/_config/default.yaml" = {
            source = yaml.generate "lima-config-default.yaml" cfg.defaults;
          };
          "lima/_config/override.yaml" = {
            source = yaml.generate "lima-config-override.yaml" cfg.overrides;
          };
        }
        // (lib.mapAttrs' (name: settings: {
          name = "lima/_templates/${name}.yaml";
          value = {
            source = yaml.generate "lima-template-${name}.yaml" settings;
          };
        }) cfg.templates);
      };
    };
}
