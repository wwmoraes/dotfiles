{ config
, lib
, pkgs
, ...
}: {
	environment.infoPath = lib.mkAfter [
		"/Library/TeX/Distributions/.DefaultTeX/Contents/Info"
	];

	homebrew.casks = [
		"mactex-no-gui"
	];
}
