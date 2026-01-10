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

      cfg = config.services.colima;
      yaml = pkgs.formats.yaml { };
      defaultDiskImages = {
        arm64 = pkgs.fetchurl {
          url = "https://github.com/abiosoft/colima-core/releases/download/v0.8.1/ubuntu-24.04-minimal-cloudimg-arm64-docker.qcow2";
          hash = "sha256-sx46QRt2TEVxH4R7QFzOhtq6eRv8vAW14m8sfz9hAdQ=";
        };
        amd64 = pkgs.fetchurl {
          url = "https://github.com/abiosoft/colima-core/releases/download/v0.8.1/ubuntu-24.04-minimal-cloudimg-amd64-docker.qcow2";
          hash = "sha256-MbDMQqgWU4gT7w8z/ZEw0qvyycVAwD7WidfenZRHgT4=";
        };
      };
      # converts colima's arch to a qemu processor name
      arch2processor = {
        aarch64 = "arm64";
        host = pkgs.stdenv.targetPlatform.uname.processor;
        x86_64 = "amd64";
        __functor = self: arch: builtins.getAttr arch self;
      };
    in
    {
      meta.maintainers = [
        lib.maintainers.wwmoraes or "wwmoraes"
      ];

      options.services.colima = {
        enable = mkEnableOption "Container runtimes on macOS (and Linux) with minimal setup";

        package = mkPackageOption pkgs "colima" {
          default = [ "colima" ];
        };

        defaultDiskImages = mkOption {
          type = with types; attrsOf package;
          description = ''
            Disk image to use for templates that do not specify a custom one.
          '';
          default = defaultDiskImages;
        };

        profiles = mkOption {
          type = with types; attrsOf (submodule ./_template.nix);
          default = { };
        };
      };

      config = mkIf cfg.enable {
        home.packages = mkIf (cfg.package != null) [
          cfg.package
        ];

        programs.docker.settings.currentContext = "colima";

        programs.ssh = {
          includes = [
            "${config.xdg.configHome}/colima/ssh_config"
          ];
        };

        home.file = builtins.listToAttrs (
          map (
            profileName:
            let
              contextName = if profileName == "default" then "colima" else "colima-${profileName}";
              # docker hashes a context name using sha256, see:
              # - https://github.com/docker/cli/blob/91d44d6cafc9ee374517f3e7aa02456e9df5033d/cli/context/store/store.go#L531-L533
              # - https://github.com/opencontainers/go-digest/blob/89707e38ad1aab6815bde4ad095806212ec90236/digest.go#L100-L102
              # - https://github.com/opencontainers/go-digest/blob/89707e38ad1aab6815bde4ad095806212ec90236/algorithm.go#L65
              # - https://github.com/opencontainers/go-digest/blob/89707e38ad1aab6815bde4ad095806212ec90236/digest.go#L142-L148
              hash = builtins.hashString "sha256" contextName;
              host = "unix://${config.xdg.configHome}/colima/${profileName}/docker.sock";
            in
            {
              name = ".docker/contexts/meta/${hash}/meta.json";
              value.text = builtins.toJSON {
                Name = contextName;
                Metadata = {
                  Description = "Colima ${profileName} profile runtime";
                  # GODEBUG = "x509negativeserial=1";
                };
                Endpoints = {
                  docker = {
                    Host = host;
                    SkipTLSVerify = false;
                  };
                };
              };
            }
          ) (builtins.attrNames cfg.profiles)
        );

        home.extraActivationPath = [
          cfg.package
          config.programs.docker.package
          config.programs.jq.package
        ]
        ++ (lib.optionals pkgs.stdenv.isDarwin [
          pkgs.darwin.DarwinTools
        ]);

        home.sessionVariables = {
          COLIMA_SAVE_CONFIG = "false";
          COLIMA_BINARY = lib.getExe cfg.package;
          # force XDG folder on all systems; colima by default uses ~/.colima on MacOS
          # see https://github.com/abiosoft/colima/blob/fe8de6ef3d36d4d0fb385cb26c63ffbe34ec9d81/config/files.go#L52-L89
          COLIMA_HOME = "${config.xdg.configHome}/colima";
        };

        xdg.configFile = lib.mapAttrs' (name: settings: {
          name = "colima/_templates/${name}.yaml";
          value = {
            source = yaml.generate "colima-template-${name}.yaml" (
              settings
              // (lib.optionalAttrs (settings.diskImage == null) {
                diskImage = builtins.getAttr (arch2processor settings.arch) cfg.defaultDiskImages;
              })
            );
            onChange = ''
              if colima list --json | jq --slurp '.[] | select(.name == "${name}")' | grep -q .; then
                echo "restarting ${name} profile..."
                run colima $VERBOSE_ARG --profile ${lib.escapeShellArg name} restart
              else
                echo "colima ${name} profile not provisioned, skipping restart"
              fi
            '';
          };
        }) cfg.profiles;

        home.activation.colimaProfiles = lib.hm.dag.entryAfter [ "writeBoundary" ] (
          builtins.concatStringsSep "\n" (
            map (name: ''
              if ! colima list --json | jq --slurp '.[] | select(.name == "${name}")' | grep -q .; then
                echo "provisioning ${name} profile..."
                run colima $VERBOSE_ARG --profile ${lib.escapeShellArg name} start
              fi
            '') (builtins.attrNames cfg.profiles)
          )
        );
      };
    };
}
