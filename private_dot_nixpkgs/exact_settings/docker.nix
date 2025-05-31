{ config
, lib
, pkgs
, ...
}: {
	environment.systemPackages = [
		pkgs.dive
		pkgs.docker
		pkgs.docker-credential-helpers
		pkgs.unstable.docker-compose-language-service
		pkgs.unstable.dockerfile-language-server-nodejs
	];

	homebrew.casks = [
		"docker"
	];

	environment.variables = {
		DOCKER_HOST = "unix://$HOME/.docker/run/docker.sock";
	};
}
