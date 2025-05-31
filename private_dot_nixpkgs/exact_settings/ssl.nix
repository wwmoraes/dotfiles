{ config
, lib
, pkgs
, ...
}: let
	sslPath = toString (/. + "${config.homebrew.brewPrefix}/../etc/openssl@3/cert.pem");
in rec {
	environment.systemPackages = [
		pkgs.cacert
	];

	environment.variables = {
		CURL_CA_BUNDLE = sslPath;
		NIX_GIT_SSL_CAINFO = sslPath;
		NIX_SSL_CERT_FILE = sslPath;
		NODE_EXTRA_CA_CERTS = sslPath;
		REQUESTS_CA_BUNDLE = sslPath;
		SSL_CERT_FILE = sslPath;
	};

	homebrew.brews = [
		"ca-certificates"
		{	name = "openssl-osx-ca"; restart_service = true; }
	];

	homebrew.taps = [
		"raggi/ale" # openssl-osx-ca
	];

	launchd.user.agents = {
		"homebrew.mxcl.openssl-osx-ca" = {
			serviceConfig = {
				Label = "homebrew.mxcl.openssl-osx-ca";
				StartInterval = 604800;
			};
		};
	};

	launchd.user.envVariables = environment.variables;

	nix = {
		settings = {
			extra-sandbox-paths = [
				sslPath
			];
			ssl-cert-file = sslPath;
		};
	};

	security.pki.certificateFiles = [
		"${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
	];
}
