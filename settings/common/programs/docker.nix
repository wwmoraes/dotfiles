{ config
, lib
, pkgs
, ...
}: rec {
	environment.systemPackages = [
		pkgs.dive
	];

	environment.variables = {
		DOCKER_HOST = "unix://$HOME/.docker/run/docker.sock";
	};

	home-manager.sharedModules = [
		({ config, ... }: lib.optionalAttrs (programs.docker.enable || services.docker.enable) {
			programs.helix.extraPackages = [
				pkgs.unstable.docker-compose-language-service
				pkgs.unstable.dockerfile-language-server-nodejs
			];
		})
	]; 

	programs.docker = {
		enable = true;
		settings = lib.mkMerge [{
			auths = {
				"https://index.docker.io/v1/" = {};
			};
			aliases = {
				builder = "buildx";
			};
			credsStore = "osxkeychain";
			currentContext = "desktop-linux";
			experimental = "disabled";
			features = {
				hooks = "false";
			};
			plugins = {
				"-x-cli-hints".enabled = "false";
				"debug".hooks = "exec";
				"scout".hooks = "pull,buildx build";
			};
		}];
	};

	services.docker = {
		enable = true;
		settings = lib.mkMerge [{
			builder = {
				features = {
					buildkit = true;
				};
				gc = {
					defaultKeepStorage = "20GB";
					enabled = true;
				};
			};
			debug = false;
			experimental = false;
		}];
	};
}
