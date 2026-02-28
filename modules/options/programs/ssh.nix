{
  lib,
  ...
}:
let
  mkOptionalListSetting =
    sep: name: values:
    lib.optional (values != null) "${name} ${builtins.concatStringsSep sep values}";
in
{
  flake.modules.darwin.default =
    {
      config,
      ...
    }:
    {
      # compatibility layer with NixOS to have proper options instead of only an
      # opaque extraConfig lines option.
      options.programs.ssh = {
        ciphers = lib.mkOption {
          type = lib.types.nullOr (lib.types.listOf lib.types.str);
          default = null;
          example = [
            "chacha20-poly1305@openssh.com"
            "aes256-gcm@openssh.com"
          ];
          description = ''
            Specifies the ciphers allowed and their order of preference.
          '';
        };
        hostKeyAlgorithms = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          example = [
            "ssh-ed25519"
            "ssh-rsa"
          ];
          description = ''
            Specifies the host key algorithms that the client wants to use in order of preference.
          '';
        };
        kexAlgorithms = lib.mkOption {
          type = lib.types.nullOr (lib.types.listOf lib.types.str);
          default = null;
          example = [
            "curve25519-sha256@libssh.org"
            "diffie-hellman-group-exchange-sha256"
          ];
          description = ''
            Specifies the available KEX (Key Exchange) algorithms.
          '';
        };
        macs = lib.mkOption {
          type = lib.types.nullOr (lib.types.listOf lib.types.str);
          default = null;
          example = [
            "hmac-sha2-512-etm@openssh.com"
            "hmac-sha1"
          ];
          description = ''
            Specifies the MAC (message authentication code) algorithms in order of preference. The MAC algorithm is used
            for data integrity protection.
          '';
        };
        pubkeyAcceptedKeyTypes = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          example = [
            "ssh-ed25519"
            "ssh-rsa"
          ];
          description = ''
            Specifies the key lib.types that will be used for public key authentication.
          '';
        };
      };

      config = {
        programs.ssh.extraConfig = builtins.concatStringsSep "\n" (
          mkOptionalListSetting "," "Ciphers" config.programs.ssh.ciphers
          ++ mkOptionalListSetting "," "HostKeyAlgorithms" config.programs.ssh.hostKeyAlgorithms
          ++ mkOptionalListSetting "," "KexAlgorithms" config.programs.ssh.kexAlgorithms
          ++ mkOptionalListSetting "," "MACs" config.programs.ssh.macs
          ++ mkOptionalListSetting "," "PubkeyAcceptedAlgorithms" config.programs.ssh.pubkeyAcceptedKeyTypes
          ++ mkOptionalListSetting "," "PubkeyAcceptedKeyTypes" config.programs.ssh.pubkeyAcceptedKeyTypes
        );
      };
    };

  flake.modules.nixos.default =
    {
      config,
      ...
    }:
    {
      programs.ssh.extraConfig = builtins.concatStringsSep "\n" (
        mkOptionalListSetting "," "PubkeyAcceptedAlgorithms" config.programs.ssh.pubkeyAcceptedKeyTypes
      );
    };
}
