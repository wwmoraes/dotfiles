{ config
, lib
, pkgs
, ...
}: {
	fonts.packages = [
		pkgs.comfortaa
		pkgs.fira-code
		pkgs.fira-code-symbols
		pkgs.montserrat
		pkgs.nerd-fonts.fira-code
		pkgs.powerline-fonts
		pkgs.powerline-symbols
		pkgs.source-code-pro
	];

	system.activationScripts.postActivation.text = (lib.concatLines (map lib.trim (lib.splitString "\n" ''
		printf >&2 "refreshing font database...\n"
		atsutil databases -removeUser 2> /dev/null
		sudo atsutil databases -remove 2> /dev/null

		# printf >&2 "Updating font cache...\n"
		# fc-cache -f

		printf >&2 "reloading font daemon...\n"
		killall fontd 2> /dev/null || true
	'')));
}
