{ config
, ...
}: {
	nix-homebrew = {
		autoMigrate = true;
		enable = true;
		enableRosetta = false;
		group = "staff";
		# mutableTaps = false;
		# taps = {
		# 	"homebrew/homebrew-core" = homebrew-core;
		# 	"homebrew/homebrew-cask" = homebrew-cask;
		# };
		user = config.system.primaryUser;
	};
}
