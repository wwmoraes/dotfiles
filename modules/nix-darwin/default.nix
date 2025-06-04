{ config
, ...
}: {
	imports = [
		./environment
		./programs
		./services
		./system

		./brew-fish-fix.nix
		./home-manager.nix
		./nix-homebrew.nix
		./sops.nix
	];

	users.users.${config.system.primaryUser} = {
		name = config.system.primaryUser;
		home = "/Users/${config.system.primaryUser}";
	};
}
