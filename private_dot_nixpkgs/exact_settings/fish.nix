{ config
, lib
, pkgs
, ...
}: {
	environment.systemPackages = [
		# pkgs.fishPlugins.fzf
		pkgs.fishPlugins.grc
		pkgs.fishPlugins.sponge
		pkgs.fishPlugins.transient-fish
	];

	environment.variables = {
		PROJECTS_ORIGIN = "git@github.com:wwmoraes/%s.git";
	};

	programs.fish = {
		babelfishPackage = pkgs.babelfish;
		enable = true;
		useBabelfish = true;
		vendor = {
			completions.enable = true;
			config.enable = true;
			functions.enable = true;
		};
	};
}
