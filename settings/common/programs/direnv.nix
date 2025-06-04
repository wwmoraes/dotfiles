{ pkgs
, ...
}: {
	environment.etc."direnv/direnv.toml" = {
		enable = true;
		source = (pkgs.formats.toml {}).generate "direnv.toml" {
			global = {
				hide_env_diff = true;
				load_dotenv = true;
				strict_env = true;
			};
		};
	};

	home-manager.sharedModules = [
		{
			home.file.".config/direnv/direnvrc" = {
				enable = true;
				text = pkgs.lib.local.unindent ''
					dotenv_if_exists ~/.secrets.env
				'';
			};

			programs.direnv = {
				enable = true;
				nix-direnv.enable = true;
				silent = true;
			};
		}
	];
}
