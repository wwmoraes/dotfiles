{ config
, pkgs
, ...
}: {
	## TODO fix upstream https://github.com/zhaofengli/nix-homebrew/blob/5108f0846cde2080aaeb1c7b08e3bd7d27f33b57/modules/default.nix#L503-L505
	config.nix-homebrew.enableFishIntegration = false;
	config.programs.fish.interactiveShellInit = pkgs.lib.local.unindent ''
		brew shellenv fish 2>/dev/null | source || true
	'';
}
