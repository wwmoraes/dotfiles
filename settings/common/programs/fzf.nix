{ config
, lib
, pkgs
, ...
}: {
	home-manager.sharedModules = [
		({ config, ... }: {
			programs.fzf = let
				batBin = lib.getExe config.programs.bat.package;
				fdBin = lib.getExe config.programs.fd.package;
				treeBin = lib.getExe pkgs.tree;
			in {
				enable = true;
				changeDirWidgetCommand = "${fdBin} --type d";
				changeDirWidgetOptions = [
					"--preview '${treeBin} -C {} | head -200"
				];
				defaultCommand = "${fdBin} --unrestricted --type f";
				defaultOptions = [
					"--bind ctrl-b:preview-page-up"
					"--bind ctrl-d:preview-down"
					"--bind ctrl-f:preview-page-down"
					"--bind ctrl-u:preview-up"
					"--height=50%"
					"--layout=reverse"
				];
				fileWidgetCommand = "${fdBin} --hidden --exclude .git --type f";
				fileWidgetOptions = [
					"--preview ${batBin} --force-colorization --style=-header-filename {}'"
				];
				historyWidgetOptions = [
					"--sort"
					"--exact"
				];
			};
		})
	];
}
