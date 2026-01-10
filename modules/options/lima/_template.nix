{
  lib,
  ...
}:
let
  inherit (lib) mkOption types;
in
{
  options = with types; {
    arch = mkOption {
      type = enum [
        "aarch64"
        "default"
        "x86_64"
      ];
      default = "default";
      description = ''
        Architecture of the virtual machine. Used on creation only.
      '';
    };
    cpus = mkOption {
      type = nullOr ints.positive;
      default = null;
      defaultText = lib.literalMD ''
        Lima built-in default: min(4, host CPU cores)
      '';
      description = ''
        Number of CPUs to be allocated to the virtual machine.
      '';
    };
    disk = mkOption {
      type = str;
      default = "100GiB";
      description = ''
        Size of the disk with unit to be allocated to the virtual machine.
      '';
    };
    images = mkOption {
      type = listOf (submodule ./_arch-locator.nix);
      default = [ ];
      description = ''
        OpenStack-compatible disk image. Each image has a `location` URL for the
        disk image, an `arch` setting, and an optional `digest`.
      '';
    };
    memory = mkOption {
      type = nullOr str;
      default = null;
      defaultText = lib.literalMD ''
        Lima built-in default: min("4GiB", half of host memory)
      '';
      description = ''
        Size of the memory with unit to be allocated to the virtual machine.
      '';
    };
    mounts = mkOption {
      type = listOf (submodule ./_mount.nix);
      default = [ ];
      description = ''
        Expose host directories to the guest, the mount point might be
        accessible from all UIDs in the guest.


        "mountPoint" can use these template variables:
        - Home
        - Name
        - Hostname
        - UID
        - User
        - Param.Key
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
    vmType = mkOption {
      type = enum [
        "qemu"
        "vz"
        "default"
      ];
      default = "default";
      defaultText = lib.literalMD ''
        Lima built-in default: "vz" (on macOS 13.5 and later), "qemu" (on others)
      '';
      description = ''
        The vmType can be specified only on creating the instance.
        The vmType of existing instances cannot be changed.
      '';
    };
    mountTypesUnsupported = mkOption {
      type = listOf str;
      default = [ ];
      description = ''
        List of mount types not supported by the kernel of this distro.
        Also used to resolve the default mount type when not explicitly specified.

        NOTE: 9p is broken in Linux v6.9, v6.10, and v6.11.
        The issue was fixed in Linux v6.12-rc5 (https://github.com/torvalds/linux/commit/be2ca38).
      '';
    };
    mountType = mkOption {
      type = nullOr (enum [
        "9p"
        "reverse-sshfs"
        "virtiofs"
        "default"
      ]);
      default = null;
      defaultText = lib.literalMD ''
        Lima built-in default: "default" (resolved to be "9p" for QEMU since Lima v1.0 on non-Windows, "virtiofs" for vz)
      '';
      description = ''
        Mount type for above mounts, such as "reverse-sshfs" (from sshocker), "9p" (QEMU’s virtio-9p-pci, aka virtfs),
        or "virtiofs" (experimental on Linux; needs `vmType: vz` on macOS).
      '';
    };
    mountInotify = mkOption {
      type = bool;
      default = false;
      description = ''
        Enable inotify support for mounted directories (EXPERIMENTAL)
      '';
    };
    additionalDisks = mkOption {
      type = listOf (either str (submodule ./_disk.nix));
      default = [ ];
      description = ''
        Lima disks to attach to the instance. The disks will be accessible from inside the
        instance, labeled by name. (e.g. if the disk is named "data", it will be labeled
        "lima-data" inside the instance). The disk will be mounted inside the instance at
        `/mnt/lima-''${VOLUME}`.
      '';
    };
    ssh = mkOption {
      type = submodule ./_ssh.nix;
      default = { };
    };
    caCerts = mkOption {
      type = submodule ./_cacert.nix;
      default = { };
    };
    upgradePackages = mkOption {
      type = bool;
      default = false;
      description = ''
        Upgrade the instance on boot. Reboot after upgrade if required.
      '';
    };
    containerd = mkOption {
      type = submodule ./_containerd.nix;
      default = { };
    };
    provision = mkOption {
      # TODO define provision submodule
      type = listOf (submodule ./_provision.nix);
      default = [ ];
      description = ''
        Provisioning scripts need to be idempotent because they might be called
        multiple times, e.g. when the host VM is being restarted.

        The scripts can use the following template variables:
        - Home
        - Name
        - Hostname
        - UID
        - User
        - Param.Key

        EXPERIMENTAL Alternatively the script can be provided using the "file" property. This file is read when the instance
        is created and then stored under the "script" property. When "file" is specified "script" must be empty.
        The "file" property can either be a string (URL), or an object with a "url" and "digest" properties.
        The "digest" property is currently unused.
        Relative script files will be resolved relative to the location of the template file.

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
    probes = mkOption {
      type = listOf (submodule ./_probe.nix);
      default = [ ];
      description = ''
        Probe scripts to check readiness. They run in user mode and must start
        with a hashbang line.

        The scripts can use the following template variables:
        - Home
        - Name
        - Hostname
        - UID
        - User
        - Param.Key

        Only `readiness` probes are supported right now.

        EXPERIMENTAL Alternatively the script can be provided using the "file"
        property. This file is read when the instance is created and then stored
        under the "script" property. When "file" is specified "script" must be
        empty. The "file" property can either be a string (URL), or an object
        with a "url" and "digest" properties. The "digest" property is currently
        unused. Relative script files will be resolved relative to the location
        of the template file.
      '';
    };
    minimumLimaVersion = mkOption {
      type = nullOr str;
      default = null;
      description = ''
        A template should specify the minimum Lima version required to parse
        this template correctly.

        It should not be set if the minimum version is less than 1.0.0.
      '';
    };
    base = mkOption {
      type = nullOr (either str (listOf (either str (submodule ./_locator.nix))));
      default = null;
      description = ''
        EXPERIMENTAL. Default settings can be imported from base templates.
        These will be merged in when the instance is created, and the combined
        template is stored in the instance directory.

        Any relative base template name will be resolved relative to the location of the main template.
      '';
      example = [
        "template:_images/ubuntu"
        "template:_default/mounts"
        "https://some.domain/base.yaml"
        {
          url = "./base.yaml";
          digest = "decafbad";
        }
      ];
    };
    user = mkOption {
      type = nullOr (submodule ./_user.nix);
      default = null;
      description = ''
        User to be used inside the VM
      '';
    };
    vmOpts = mkOption {
      type = nullOr (submodule {
        qemu = mkOption {
          type = submodule ./_qemu.nix;
          default = { };
        };
        vz = mkOption {
          type = submodule ./_vz.nix;
          default = { };
        };
      });
      default = null;
    };
    os = mkOption {
      type = nullOr str;
      default = null;
      defaultText = lib.literalMD ''
        Lima built-in default: "Linux"
      '';
      description = ''
        OS: "Linux".
      '';
    };
    timezone = mkOption {
      type = nullOr str;
      default = null;
      defaultText = lib.literalMD ''
        Lima built-in default: use name from /etc/timezone or deduce from
        symlink target of /etc/localtime
      '';
      description = ''
        Specify the timezone name (as used by the zoneinfo database). Specify
        the empty string to not set a timezone in the instance.
      '';
    };
    firmware = mkOption {
      type = nullOr anything;
      default = null;
    };
    audio = mkOption {
      type = nullOr anything;
      default = null;
    };
    video = mkOption {
      type = nullOr anything;
      default = null;
    };
    networks = mkOption {
      type = nullOr anything;
      default = null;
    };
    propagateProxyEnv = mkOption {
      type = nullOr anything;
      default = null;
    };
    hostResolver = mkOption {
      type = nullOr anything;
      default = null;
    };
    guestInstallPrefix = mkOption {
      type = nullOr anything;
      default = null;
    };
    plain = mkOption {
      type = nullOr anything;
      default = null;
    };
    nestedVirtualization = mkOption {
      type = bool;
      default = false;
      description = ''
        Allows running a VM inside the guest VM. The guest VM must
        configure QEMU with the `-cpu host` parameters to run a nested
        VM: `qemu-system-aarch64 -accel kvm -cpu host -M virt`. Without
        specifying `-cpu host`, nested virtualization may fail with the error:
        `qemu-system-aarch64: kvm_init_vcpu: kvm_arch_init_vcpu failed (0):
        Invalid argument`.

        Only supported on Apple M3 or later with `vmType: vz`.
      '';
    };
  };
}
