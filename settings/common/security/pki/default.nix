let
  ## TODO implement security.pki.caBundle from NixOS in nix-darwin
  caBundle = "/etc/ssl/certs/ca-certificates.crt";
in
{
  environment.variables = {
    CURL_CA_BUNDLE = caBundle;
    GIT_SSL_CAINFO = caBundle;
    NIX_GIT_SSL_CAINFO = caBundle;
    NIX_SSL_CERT_FILE = caBundle;
    NODE_EXTRA_CA_CERTS = caBundle;
    REQUESTS_CA_BUNDLE = caBundle;
    SSL_CERT_FILE = caBundle;
    SYSTEM_CERTIFICATE_PATH = caBundle;
  };
}
