{ config
, lib
, pkgs
, ...
}: {
	home-manager.sharedModules = [({ config, ... }: {
		programs.powerline-go = {
			enable = true;
			modules = [
				"user"
				"host"
				"ssh"
				"cwd"
				"docker"
				"kube"
				"git"
			];
			modulesRight = [
				"newline"
				"vi-mode"
				"duration"
				"nix-shell"
				"perms"
				"jobs"
				"exit"
				"root"
			];
			pathAliases = {
				"~" = "🏡";
				"~/.local/share/chezmoi" = "🧰";
				"~/dev" = "💻";
				"~/workspace" = "🏢";
			};
			settings = {
				cwd-max-depth = 3;
				duration-low-precision = true;
				duration-min = "0.6";
				hostname-only-if-ssh = true;
				numeric-exit-codes = true;
				priority = [
					"newline"
					"jobs"
					"exit"
					"user"
					"host"
					"ssh"
					"cwd"
					"root"
					"nix-shell"
					"dotenv"
					"goenv"
					"perms"
					"git"
					"duration"
					"docker"
					"kube"
				];
				# shell = "bare";
			};
		};

	})];
}
