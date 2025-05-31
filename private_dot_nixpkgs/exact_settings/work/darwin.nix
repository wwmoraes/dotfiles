{ config
, lib
, pkgs
, ...
}: {
	nixpkgs.hostPlatform = "aarch64-darwin";

	system.primaryUser = "william";
}
