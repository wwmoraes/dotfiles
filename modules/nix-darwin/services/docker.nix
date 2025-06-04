{
  config,
  lib,
  pkgs,
  ...
}: let
	  inherit (lib)
		mkEnableOption
		mkPackageOption
		types
    mkOption
    ;

	cfg = config.services.docker;
	configText = lib.generators.toJSON {} cfg.settings;
in {
	meta.maintainers = [
		lib.maintainers.wwmoraes or "wwmoraes"
	];

	options = {
		services.docker = {
      enable = mkEnableOption "Docker daemon to run containerized applications";

			package = mkPackageOption pkgs "docker" {
				nullable = true;
				default = "docker";
			};

      settings = mkOption {
        default = { };
				type = with types; attrsOf anything;
			};
		};
	};

	## TODO converge docker settings with NixOS options
	## see https://search.nixos.org/options?channel=25.05&show=virtualisation.docker.daemon.settings&from=0&size=50&sort=relevance&type=packages&query=virtualisation.docker
	config = {
		## TODO move rootless docker configuration to virtualisation group
		## https://github.com/NixOS/nixpkgs/blob/nixos-25.05/nixos/modules/virtualisation/docker-rootless.nix
		environment.etc."docker-linux-root-daemon-json" = {
			enable = cfg.enable && !pkgs.stdenv.hostPlatform.isDarwin;
			target = "docker/daemon.json";
			text = configText;
		};

		environment.systemPackages = lib.optional cfg.enable cfg.package;

		home-manager.sharedModules = [{
			home.file."docker-darwin-daemon-json" = {
				enable = cfg.enable && pkgs.stdenv.hostPlatform.isDarwin;
				target = ".docker/daemon.json";
				text = configText;
			};
			xdg.configFile."docker-linux-rootless-daemon-json" = {
				enable = cfg.enable && pkgs.stdenv.hostPlatform.isLinux;
				target = "docker/daemon.json";
				text = configText;
			};
		}];

		homebrew.casks = lib.optional cfg.enable "docker";
	};
}
