{ config
, pkgs
, ...
}: {
	home-manager = {
		backupFileExtension = "bkp";
		sharedModules = [
			../home-manager
		];
		useGlobalPkgs = true;
		useUserPackages = true;
		users.${config.system.primaryUser} = {
			home.homeDirectory =
				if pkgs.stdenv.hostPlatform.isDarwin
				then "/Users/${config.system.primaryUser}"
				else "/home/${config.system.primaryUser}";
		};
	};
}
