{
  flake.modules.homeManager.default =
    {
      config,
      darwinConfig,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib)
        mkEnableOption
        mkIf
        mkOption
        types
        ;

      cfg = config.targets.darwin.linux-builder;
    in
    {
      meta.maintainers = [
        lib.maintainers.wwmoraes or "wwmoraes"
      ];

      options.targets.darwin.linux-builder = with types; {
        enable = mkEnableOption "Nix userland Linux builder";

        config = mkOption {
          type = deferredModule;
          default = { };
          example = literalExpression ''
            ({ pkgs, ... }:

            {
              environment.systemPackages = [ pkgs.neovim ];
            })
          '';
          description = ''
            This option specifies extra NixOS configuration for the builder.
            You should first use the Linux builder without changing the builder
            configuration otherwise you may not be able to build the Linux builder.
          '';
        };
        workingDirectory = mkOption {
          default = "${config.xdg.stateHome}/linux-builder";
          type = str;
          example = "/Users/your-user/.local/state/linux-builder";
          description = ''
            The working directory to use to run the script.
          '';
        };
        package = mkOption {
          type = package;
          default = pkgs.callPackage ./_package.nix { inherit config; };
          apply =
            pkg:
            pkg.override (old: {
              modules = old.modules ++ [
                cfg.config
              ];
            });
          description = ''
            This option specifies the Linux builder to use.
          '';
        };
        hostPort = mkOption {
          default = 31022;
          type = port;
          example = 31022;
          description = ''
            The localhost host port to forward TCP to the guest port.
          '';
        };
      };

      config = mkIf cfg.enable {
        home.activation.linuxBuilder = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          mkdir -p ${cfg.workingDirectory}
        '';

        launchd.agents.linux-builder = {
          enable = true;
          config = {
            Label = "org.nix-community.home.linux-builder";
            EnvironmentVariables = {
              inherit (darwinConfig.environment.variables) NIX_SSL_CERT_FILE;
              QEMU_OPTS = "-nographic";
            };
            KeepAlive = false;
            RunAtLoad = false;
            WorkingDirectory = cfg.workingDirectory;
            Sockets.Listener = {
              SockFamily = "IPv4";
              SockNodeName = "127.0.0.1";
              SockPassive = false;
              SockServiceName = toString cfg.hostPort;
            };
            StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/${config.launchd.agents.linux-builder.config.Label}.err.log";
            StandardOutPath = "${config.home.homeDirectory}/Library/Logs/${config.launchd.agents.linux-builder.config.Label}.out.log";
            ProgramArguments = [
              "/bin/sh"
              "-c"
              "/bin/wait4path /nix/store && ${lib.getExe cfg.package}"
            ];
          };
        };

        programs.ssh = {
          matchBlocks = {
            "linux-builder" = {
              hostname = "localhost";
              user = "builder";
              extraOptions = {
                hostKeyAlias = "linux-builder";
              };
              port = cfg.hostPort;
              identityFile = cfg.package.builderPrivateKeyPath;
            };
          };
        };

        nix.distributedBuilds = true;
        nix.buildMachines = [
          {
            hostName = "linux-builder";
            sshUser = "builder";
            sshKey = cfg.package.builderPrivateKeyPath;
            # publicHostKey = "base64 -w0 ${cfg.package.builderPublicKeyPath}"; # gitleaks:allow
            maxJobs = cfg.package.nixosConfig.virtualisation.cores;
            protocol = "ssh-ng";
            speedFactor = 1;
            supportedFeatures = [
              "kvm"
              "benchmark"
              "big-parallel"
            ];
            inherit (cfg.package) systems;
          }
        ];

        services.lima = {
          instances.linux-builder.source = "linux-builder";
          templates.linux-builder = {
            containerd = {
              system = false;
              user = false;
            };
            cpus = 2;
            disk = "80GiB";
            images = [
              {
                location = pkgs.folkvangr-image;
                arch = "aarch64";
              }
            ];
            memory = "2GiB";
            minimumLimaVersion = "2.0.0";
            mounts = [
              {
                location = "~";
              }
            ];
            vmType = "vz";
          };
        };

        # xdg.configFile = {
        #   "nix/ssh/linux-builder_ed25519" = {
        #     mode = "0600";
        #     source = ./keys/ed25519;
        #   };
        #   "nix/ssh/linux-builder_ed25519.pub" = {
        #     mode = "0644";
        #     source = ./keys/ed25519.pub;
        #   };
        # };
      };
    };
}
