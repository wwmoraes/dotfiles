{
  lib,
  ...
}:
let
  inherit (lib) mkOption types;
in
{
  options = with types; {
    cpu = mkOption {
      type = ints.unsigned;
      default = 2;
      description = ''
        Number of CPUs to be allocated to the virtual machine.
      '';
    };
    disk = mkOption {
      type = ints.unsigned;
      default = 100;
      description = ''
        Size of the disk in GiB to be allocated to the virtual machine.

        NOTE: value can only be increased after virtual machine has been created.
      '';
    };
    memory = mkOption {
      type = ints.unsigned;
      default = 2;
      description = ''
        Size of the memory in GiB to be allocated to the virtual machine.
      '';
    };
    arch = mkOption {
      type = enum [
        "aarch64"
        "host"
        "x86_64"
      ];
      default = "host";
      description = ''
        Architecture of the virtual machine (x86_64, aarch64, host).

        NOTE: value cannot be changed after virtual machine is created.
      '';
    };
    runtime = mkOption {
      type = str;
      default = "docker";
      description = ''
        Container runtime to be used (docker, containerd).

        NOTE: value cannot be changed after virtual machine is created.
      '';
    };
    hostname = mkOption {
      type = nullOr str;
      default = null;
      description = ''
        Set custom hostname for the virtual machine.
        Default: colima (colima-profile_name for other profiles)
      '';
    };
    kubernetes = mkOption {
      type = submodule ./_kubernetes.nix;
      default = { };
      description = ''
        Kubernetes configuration for the virtual machine.
      '';
    };
    autoActivate = mkOption {
      type = bool;
      default = true;
      description = ''
        Auto-activate on the Host for client access.
        Setting to true does the following on startup
        - sets as active Docker context (for Docker runtime).
        - sets as active Kubernetes context (if Kubernetes is enabled).
      '';
    };
    network = mkOption {
      type = submodule ./_network.nix;
      default = { };
      description = ''
        Network configurations for the virtual machine.
      '';
    };
    forwardAgent = mkOption {
      type = bool;
      default = false;
      description = ''
        Forward the host's SSH agent to the virtual machine.
      '';
    };
    docker = mkOption {
      type = attrsOf anything;
      default = { };
      description = ''
        Docker daemon configuration that maps directly to daemon.json.
        https://docs.docker.com/engine/reference/commandline/dockerd/#daemon-configuration-file.
        NOTE: some settings may affect Colima's ability to start docker. e.g. `hosts`.

        Colima default behaviour: buildkit enabled
      '';
      example = {
        features = {
          buildkit = false;
        };
        insecure-registries = [
          "myregistry.com:5000"
          "host.docker.internal:5000"
        ];
      };
    };
    vmType = mkOption {
      type = enum [
        "qemu"
        "vz"
      ];
      default = "qemu";
      description = ''
        Virtual Machine type (qemu, vz)

        NOTE: this is macOS 13 only. For Linux and macOS <13.0, qemu is always used.

        vz is macOS virtualization framework and requires macOS 13

        NOTE: value cannot be changed after virtual machine is created.
      '';
    };
    rosetta = mkOption {
      type = bool;
      default = false;
      description = ''
        Utilise rosetta for amd64 emulation (requires m1 mac and vmType `vz`)
      '';
    };
    nestedVirtualization = mkOption {
      type = bool;
      default = false;
      description = ''
        Enable nested virtualization for the virtual machine (requires m3 mac and vmType `vz`)
      '';
    };
    mountType = mkOption {
      type = nullOr str;
      default = null;
      description = ''
        Volume mount driver for the virtual machine (virtiofs, 9p, sshfs).

        virtiofs is limited to macOS and vmType `vz`. It is the fastest of the options.

        9p is the recommended and the most stable option for vmType `qemu`.

        sshfs is faster than 9p but the least reliable of the options (when there are lots
        of concurrent reads or writes).

        NOTE: value cannot be changed after virtual machine is created.
        Default: virtiofs (for vz), sshfs (for qemu)
      '';
    };
    mountInotify = mkOption {
      type = bool;
      default = false;
      description = ''
        Propagate inotify file events to the VM.
        NOTE: this is experimental.
      '';
    };
    cpuType = mkOption {
      type = str;
      default = "host";
      description = ''
        The CPU type for the virtual machine (requires vmType `qemu`).
        Options available for host emulation can be checked with: `qemu-system-$(arch) -cpu help`.
        Instructions are also supported by appending to the cpu type e.g. "qemu64,+ssse3".
      '';
    };
    provision = mkOption {
      # TODO define provision submodule
      type = listOf (
        attrsOf (submodule {
          mode = mkOption {
            type = enum [
              "system"
              "user"
            ];
          };
          script = mkOption {
            type = str;
            default = "";
          };
        })
      );
      default = [ ];
      description = ''
        Custom provision scripts for the virtual machine.
        Provisioning scripts are executed on startup and therefore needs to be idempotent.
      '';
      example = [
        {
          mode = "system";
          script = "apt-get install htop vim";
        }
        {
          mode = "user";
          script = ''
            [ -f ~/.provision ] && exit 0;
            echo provisioning as $USER...
            touch ~/.provision
          '';
        }
      ];
    };
    sshConfig = mkOption {
      type = bool;
      default = true;
      description = ''
        Modify ~/.ssh/config automatically to include a SSH config for the virtual machine.
        SSH config will still be generated in $COLIMA_HOME/ssh_config regardless.
      '';
    };
    sshPort = mkOption {
      type = ints.unsigned;
      default = 0;
      description = ''
        The port number for the SSH server for the virtual machine.
        When set to 0, a random available port is used.
      '';
    };
    mounts = mkOption {
      type = listOf (submodule {
        location = mkOption {
          type = str;
        };
        writable = mkOption {
          type = bool;
        };
      });
      default = [ ];
      description = ''
        Configure volume mounts for the virtual machine.
        Colima mounts user's home directory by default to provide a familiar
        user experience.

        Colima default behaviour: $HOME and /tmp/colima are mounted as writable.
      '';
      example = [
        {
          location = "~/secrets";
          writable = false;
        }
        {
          location = "~/projects";
          writable = true;
        }
      ];
    };
    diskImage = mkOption {
      type = nullOr package;
      default = null;
      description = ''
        Specify a custom disk image to provision the the virtual machine with.
        Uses the default disk image from the service definition if none is set.
        For images see https://github.com/abiosoft/colima-core/releases.

        The image used MUST match the ones set for your colima
        CLI version. Check the source for what images are usable at
        https://github.com/abiosoft/colima/blob/v<VERSION>/embedded/images/images.txt,
        changing <VERSION> with your colima CLI version.
      '';
    };
    env = mkOption {
      type = attrsOf str;
      default = { };
      description = ''
        Environment variables for the virtual machine.
      '';
      example = {
        KEY = "value";
        ANOTHER_KEY = "another value";
      };
    };
  };
}
