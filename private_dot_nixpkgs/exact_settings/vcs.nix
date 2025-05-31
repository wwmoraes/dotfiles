{ config
, lib
, pkgs
, ...
}: {
	environment.systemPackages = [
		pkgs.delta
		pkgs.gh
		pkgs.git
		pkgs.tig
		pkgs.tkdiff
		pkgs.unstable.git-ps-rs
		pkgs.unstable.lazygit
	];
}
