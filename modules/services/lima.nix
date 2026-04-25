{
  flake.modules.darwin.development =
    {
      config,
      ...
    }:
    {
      system.defaults.CustomSystemPreferences."/Library/Preferences/com.apple.TimeMachine".SkipPaths =
        config.users.users
        |> builtins.attrValues
        |> builtins.concatMap (user: [
          "${user.home}/.lima"
        ]);
    };

  flake.modules.homeManager.development =
    {
      pkgs,
      ...
    }:
    {
      # TODO image from store
      # arch=aarch64 digest="sha256:9d8e0c98858d53866117d5c701a554a9d2434bedffec1c0ab7253691bfd2c70e" location="https://cloud-images.ubuntu.com/releases/oracular/release-20250305/ubuntu-24.10-server-cloudimg-arm64.img"
      services.lima = {
        enable = false;

        baseConfig = {
          base = [
            "template:docker"
          ];
        };

        instances.default = {
          source = "default";
        };

        templates.default = {
          containerd = {
            system = false;
            user = false;
          };
          cpus = 2;
          disk = "80GiB";
          images = [
            {
              location = pkgs.fetchurl {
                url = "https://dl-cdn.alpinelinux.org/alpine/v3.22/releases/cloud/nocloud_alpine-3.22.2-x86_64-uefi-cloudinit-r0.qcow2";
                hash = "sha256-DI4QqXl9jXhbjwI7e359TzX/rfogZIs07aLVHvmHSYk=";
              };
              arch = "x86_64";
              digest = "sha512:6dcb2ec1ac3ff160f1a2609fbd7cb8417df6c1c937c259238090d5bc494778924c0eb360c926d90bfbe7d0176692ae00b049f4a06d5070618a3b087a47c96532";
            }
            {
              location = pkgs.fetchurl {
                url = "https://dl-cdn.alpinelinux.org/alpine/v3.22/releases/cloud/nocloud_alpine-3.22.2-aarch64-uefi-cloudinit-r0.qcow2";
                hash = "sha256-cCnUClZ9z+uaL/9o4TH0hM8DwmP9EVBVKdWQbYx52+w=";
              };
              arch = "aarch64";
              digest = "sha512:481ad2db4fe024dd5d2dddd2abf2f722b738173c9ff6b76425ee877706bd49e26b2877ccae7b389aebae1d5e8df0384cc3c8355fc903378997340ce6c1b85faf";
            }
          ];
          memory = "2GiB";
          minimumLimaVersion = "2.0.0";
          mounts = [
            {
              location = "~";
            }
          ];
          provision = [
            {
              mode = "system";
              script = ''
                #!/bin/bash
                apk add --no-cache docker
              '';
            }
          ];
          vmType = "vz";
        };
      };
    };
}
