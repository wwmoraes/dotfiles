{ pkgs
, ...
}: {
	imports = [
		./powerline-go.nix
	];

	disabledModules = [
		"programs/powerline-go.nix"
	];

	home.enableNixpkgsReleaseCheck = true;
	home.stateVersion = "25.05";
}
