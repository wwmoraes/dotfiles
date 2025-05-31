{ config
, lib
, pkgs
, ...
}: {
	environment.systemPackages = [
		pkgs.fzf
	];

	environment.variables = {
		FZF_COMPLETE = "1";
		FZF_DEFAULT_OPTS = (lib.concatStringsSep " " [
			"--bind ctrl-b:preview-page-up"
			"--bind ctrl-d:preview-down"
			"--bind ctrl-f:preview-page-down"
			"--bind ctrl-u:preview-up"
			"--height=50%"
			"--layout=reverse"
		]);
		FZF_LEGACY_KEYBINDINGS = "0";
		FZF_REVERSE_ISEARCH_OPTS = (lib.concatStringsSep " " [
			"--height=50%"
			"--preview-window=up:10"
			"--preview='bat {}'"
		]);
	};
}
