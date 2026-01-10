{
  lib,
  ...
}:
let
  inherit (lib) mkOption types;
in
{
  options = with types; {
    removeDefaults = mkOption {
      type = bool;
      default = false;
      description = ''
        If set to `true`, this will remove all the default trusted CA
        certificates that are normally shipped with the OS.
      '';
    };

    files = mkOption {
      type = listOf path;
      default = [ ];
      description = ''
        A list of trusted CA certificate files. The files will be read and passed to cloud-init.
      '';
      example = lib.literalExpression ''
        [
          ./examples/hello.crt
        ]
      '';
    };

    certs = mkOption {
      type = listOf str;
      default = [ ];
      description = ''
        A list of trusted CA certificates. These are directly passed to cloud-init.
      '';
      example = [
        ''
          -----BEGIN CERTIFICATE-----
          YOUR-ORGS-TRUSTED-CA-CERT-HERE
          -----END CERTIFICATE-----
        ''
        ''
          -----BEGIN CERTIFICATE-----
          YOUR-ORGS-TRUSTED-CA-CERT-HERE
          -----END CERTIFICATE-----
        ''
      ];
    };
  };
}
