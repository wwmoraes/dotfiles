{ config
, lib
, pkgs
, ...
}: {
	environment.systemPath = lib.mkBefore [
		"$HOME/.go/bin"
	];

	environment.variables = {
		CGO_ENABLED = "0";
		GOPATH = "$HOME/.go";
	};
}
