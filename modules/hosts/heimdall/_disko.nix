{
  lib,
  ...
}:
{
  disko.devices = {
    disk.ssd = {
      device = "/dev/nvme0n1";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            name = "boot";
            size = "1M";
            type = "EF02";
          };
          esp = {
            name = "ESP";
            size = "500M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          pool = {
            name = "pool";
            size = "100%";
            content = {
              type = "lvm_pv";
              vg = "pool";
            };
          };
        };
      };
    };
    lvm_vg = {
      pool = {
        type = "lvm_vg";
        lvs = {
          keys = {
            size = "1M";
            content = {
              name = "keys";
              type = "luks";
              enrollFido2 = true;
              initrdUnlock = true;
              extraFormatArgs = [
                "--type luks2"
                "--pbkdf argon2id"
              ];
              # BUG: initrdUnlock adds the fido2-device=auto option, however
              # the upstream disko module code does an attribute set update
              # with settings.crypttabExtraOpts at the right side; since that
              # operator does a shallow merge, any module options set by disko
              # are lost.
              settings = {
                crypttabExtraOpts = lib.mkAfter [
                  "fido2-device=auto"
                  "token-timeout=10"
                ];
              };
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/usr/local/share/misc/keys";
                mountOptions = [
                  "defaults"
                  "noatime"
                  "nodev"
                  "noexec"
                ];
              };
            };
          };
          main = {
            size = "100%FREE";
            content = {
              type = "btrfs";
              extraArgs = [
                "-L"
                "nixos"
                "-f"
              ];
              subvolumes = {
                "@" = {
                  mountpoint = "/";
                  mountOptions = [
                    "defaults"
                    "compress=zstd"
                    "noatime"
                  ];
                };
                "@nix" = {
                  mountpoint = "/nix";
                  mountOptions = [
                    "defaults"
                    "compress=zstd"
                    "noatime"
                  ];
                };
                "@home" = {
                  mountpoint = "/home";
                  mountOptions = [
                    "defaults"
                    "compress=zstd"
                    "noatime"
                  ];
                };
                "@root" = {
                  mountpoint = "/root";
                  mountOptions = [
                    "defaults"
                    "compress=zstd"
                    "noatime"
                  ];
                };
                "@etc" = {
                  mountpoint = "/etc";
                  mountOptions = [
                    "defaults"
                    "compress=zstd"
                    "noatime"
                    "noexec"
                    "nodev"
                  ];
                };
                "@log" = {
                  mountpoint = "/var/log";
                  mountOptions = [
                    "defaults"
                    "compress=zstd"
                    "noatime"
                    "noexec"
                    "nodev"
                  ];
                };
                "@lib" = {
                  mountpoint = "/var/lib";
                  mountOptions = [
                    "defaults"
                    "compress=zstd"
                    "noatime"
                    "noexec"
                    "nodev"
                  ];
                };
                "@srv" = {
                  mountpoint = "/srv";
                  mountOptions = [
                    "defaults"
                    "compress=zstd"
                    "noatime"
                    "noexec"
                    "nodev"
                  ];
                };
                "@swap" = {
                  mountpoint = "/run/swap";
                  mountOptions = [
                    "defaults"
                    "noatime"
                    "nodatacow"
                    "compress=no"
                    "noexec"
                    "nodev"
                  ];
                  swap.default.size = "64G";
                };
              };
            };
          };
        };
      };
    };
  };
}
