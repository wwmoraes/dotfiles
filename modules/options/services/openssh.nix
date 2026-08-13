{
  lib,
  ...
}:
{
  flake.modules.darwin.default =
    {
      config,
      ...
    }:
    let
      cfg = config.services.openssh;
    in
    {
      # compatibility layer with NixOS to have proper options instead of only an
      # opaque extraConfig lines option.
      options.services.openssh = {
        settings = lib.mkOption {
          description = "Configuration for `sshd_config(5)`.";
          default = { };
          example = lib.literalExpression ''
            {
              UseDns = true;
              PasswordAuthentication = false;
            }
          '';
          type = lib.types.submodule {
            freeformType = lib.types.attrs;
            options = {
              AuthorizedPrincipalsFile = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = "none"; # upstream default
                description = ''
                  Specifies a file that lists principal names that are accepted for certificate authentication. The default
                  is `"none"`, i.e. not to use a principals file.
                '';
              };
              LogLevel = lib.mkOption {
                type = lib.types.nullOr (
                  lib.types.enum [
                    "QUIET"
                    "FATAL"
                    "ERROR"
                    "INFO"
                    "VERBOSE"
                    "DEBUG"
                    "DEBUG1"
                    "DEBUG2"
                    "DEBUG3"
                  ]
                );
                default = "INFO"; # upstream default
                description = ''
                  Gives the verbosity level that is used when logging messages from {manpage}`sshd(8)`. Logging with a DEBUG level
                  violates the privacy of users and is not recommended.
                '';
              };
              UsePAM = lib.mkEnableOption "PAM authentication" // {
                default = true;
                type = lib.types.nullOr lib.types.bool;
              };
              UseDns = lib.mkOption {
                type = lib.types.nullOr lib.types.bool;
                default = false;
                description = ''
                  Specifies whether {manpage}`sshd(8)` should look up the remote host name, and to check that the resolved host name for
                  the remote IP address maps back to the very same IP address.
                  If this option is set to no (the default) then only addresses and not host names may be used in
                  ~/.ssh/authorized_keys from and sshd_config Match Host directives.
                '';
              };
              X11Forwarding = lib.mkOption {
                type = lib.types.nullOr lib.types.bool;
                default = false;
                description = ''
                  Whether to allow X11 connections to be forwarded.
                '';
              };
              PasswordAuthentication = lib.mkOption {
                type = lib.types.nullOr lib.types.bool;
                default = true;
                description = ''
                  Specifies whether password authentication is allowed.
                '';
              };
              PermitRootLogin = lib.mkOption {
                default = "prohibit-password";
                type = lib.types.nullOr (
                  lib.types.enum [
                    "yes"
                    "without-password"
                    "prohibit-password"
                    "forced-commands-only"
                    "no"
                  ]
                );
                description = ''
                  Whether the root user can login using ssh.
                '';
              };
              KbdInteractiveAuthentication = lib.mkOption {
                type = lib.types.nullOr lib.types.bool;
                default = true;
                description = ''
                  Specifies whether keyboard-interactive authentication is allowed.
                '';
              };
              GatewayPorts = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = "no";
                description = ''
                  Specifies whether remote hosts are allowed to connect to
                  ports forwarded for the client.  See
                  {manpage}`sshd_config(5)`.
                '';
              };
              KexAlgorithms = lib.mkOption {
                type = lib.types.nullOr (lib.types.listOf lib.types.str);
                default = [
                  "mlkem768x25519-sha256"
                  "sntrup761x25519-sha512"
                  "sntrup761x25519-sha512@openssh.com"
                  "curve25519-sha256"
                  "curve25519-sha256@libssh.org"
                  "diffie-hellman-group-exchange-sha256"
                ];
                description = ''
                  Allowed key exchange algorithms

                  Uses the lower bound recommended in both
                  <https://stribika.github.io/2015/01/04/secure-secure-shell.html>
                  and
                  <https://infosec.mozilla.org/guidelines/openssh#modern-openssh-67>
                '';
              };
              Macs = lib.mkOption {
                type = lib.types.nullOr (lib.types.listOf lib.types.str);
                default = [
                  "hmac-sha2-512-etm@openssh.com"
                  "hmac-sha2-256-etm@openssh.com"
                  "umac-128-etm@openssh.com"
                ];
                description = ''
                  Allowed MACs

                  Defaults to recommended settings from both
                  <https://stribika.github.io/2015/01/04/secure-secure-shell.html>
                  and
                  <https://infosec.mozilla.org/guidelines/openssh#modern-openssh-67>
                '';
              };
              StrictModes = lib.mkOption {
                type = lib.types.nullOr lib.types.bool;
                default = true;
                description = ''
                  Whether sshd should check file modes and ownership of directories
                '';
              };
              Ciphers = lib.mkOption {
                type = lib.types.nullOr (lib.types.listOf lib.types.str);
                default = [
                  "chacha20-poly1305@openssh.com"
                  "aes256-gcm@openssh.com"
                  "aes128-gcm@openssh.com"
                  "aes256-ctr"
                  "aes192-ctr"
                  "aes128-ctr"
                ];
                description = ''
                  Allowed ciphers

                  Defaults to recommended settings from both
                  <https://stribika.github.io/2015/01/04/secure-secure-shell.html>
                  and
                  <https://infosec.mozilla.org/guidelines/openssh#modern-openssh-67>
                '';
              };
              AllowUsers = lib.mkOption {
                type = with lib.types; nullOr (listOf str);
                default = null;
                description = ''
                  If specified, login is allowed only for the listed users.
                  See {manpage}`sshd_config(5)` for details.
                '';
              };
              DenyUsers = lib.mkOption {
                type = with lib.types; nullOr (listOf str);
                default = null;
                description = ''
                  If specified, login is denied for all listed users. Takes
                  precedence over [](#opt-services.openssh.settings.AllowUsers).
                  See {manpage}`sshd_config(5)` for details.
                '';
              };
              AllowGroups = lib.mkOption {
                type = with lib.types; nullOr (listOf str);
                default = null;
                description = ''
                  If specified, login is allowed only for users part of the
                  listed groups.
                  See {manpage}`sshd_config(5)` for details.
                '';
              };
              DenyGroups = lib.mkOption {
                type = with lib.types; nullOr (listOf str);
                default = null;
                description = ''
                  If specified, login is denied for all users part of the listed
                  groups. Takes precedence over
                  [](#opt-services.openssh.settings.AllowGroups). See
                  {manpage}`sshd_config(5)` for details.
                '';
              };
              # Disabled by default, since pam_motd handles this.
              PrintMotd = lib.mkEnableOption "printing /etc/motd when a user logs in interactively" // {
                type = lib.types.nullOr lib.types.bool;
              };
            };
          };
        };
      };

      config = {
        services.openssh.extraConfig =
          let
            # OpenSSH is very inconsistent with options that can take multiple values.
            # For some of them, they can simply appear multiple times and are appended, for others the
            # values must be separated by whitespace or even commas.
            # Consult either sshd_config(5) or, as last resort, the OpehSSH source for parsing
            # the options at servconf.c:process_server_config_line_depth() to determine the right "mode"
            # for each. But fortunately this fact is documented for most of them in the manpage.
            commaSeparated = [
              "Ciphers"
              "KexAlgorithms"
              "Macs"
            ];
            spaceSeparated = [
              "AuthorizedKeysFile"
              "AllowGroups"
              "AllowUsers"
              "DenyGroups"
              "DenyUsers"
            ];
          in
          cfg.settings
          |> lib.mapAttrs (
            key: val:
            if lib.isList val then
              if lib.elem key commaSeparated then
                lib.concatStringsSep "," val
              else if lib.elem key spaceSeparated then
                lib.concatStringsSep " " val
              else
                throw "list value for unknown key ${key}: ${(lib.generators.toPretty { }) val}"
            else
              val
          )
          |> lib.filterAttrs (k: v: v != null)
          |> lib.generators.toKeyValue {
            mkKeyValue =
              let
                mkValueString =
                  v:
                  if lib.isInt v then
                    toString v
                  else if lib.isString v then
                    v
                  else if true == v then
                    "yes"
                  else if false == v then
                    "no"
                  else
                    throw "unsupported type ${builtins.typeOf v}: ${(lib.generators.toPretty { }) v}";
              in
              k: v: "${k} ${mkValueString v}";
          };
      };
    };
}
