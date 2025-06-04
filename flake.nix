{
	description = "wwmoraes' dotfiles on steroids";

	inputs = {
		flake-parts.url = "github:hercules-ci/flake-parts";
		home-manager = {
			inputs.nixpkgs.follows = "nixpkgs";
			url = "github:nix-community/home-manager/release-25.05";
		};
		# homebrew-cask = {
		# 	url = "github:homebrew/homebrew-cask";
		# 	flake = false;
		# };
		# homebrew-core = {
		# 	url = "github:homebrew/homebrew-core";
		# 	flake = false;
		# };
		nix-darwin = {
			inputs.nixpkgs.follows = "nixpkgs";
			url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
		};
		nix-homebrew.url = "github:zhaofengli/nix-homebrew";
		nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
		nur = {
			inputs.nixpkgs.follows = "nixpkgs";
			inputs.flake-parts.follows = "flake-parts";
			url = "github:nix-community/NUR";
		};
		sops-nix = {
			inputs.nixpkgs.follows = "nixpkgs";
			url = "github:Mic92/sops-nix";
		};
		unstable.url = "github:NixOS/nixpkgs?rev=e38c80c027d6bbdfa2a305fc08e732b9fac4928a";
	};

	outputs = inputs@{
		self,
		flake-parts,
		home-manager,
		# homebrew-cask,
		# homebrew-core,
		nix-darwin,
		nix-homebrew,
		nixpkgs,
		nur,
		sops-nix,
		unstable,
		...
	}: (flake-parts.lib.mkFlake { inherit inputs; } {
		flake = rec {
			# getLanguage = name: (builtins.filter (entry: entry.name == name) darwinConfigurations.M1Cabuk.config.home-manager.users.william.programs.helix.languages.language);

			darwinModules = {
				default = { config, pkgs, ... }: {
					imports = [
						nix-homebrew.darwinModules.nix-homebrew
						(nixpkgs + /nixos/modules/programs/less.nix)
						./modules/nix-darwin
					];

					environment.systemPackages = [
						self.packages.${pkgs.system}.darwin-rebuild
						self.packages.${pkgs.system}.switch-home
						self.packages.${pkgs.system}.switch-system
					];

					home-manager.sharedModules = [
						sops-nix.homeManagerModules.sops
					];

					nixpkgs = {
						overlays = [
						 	self.overlays.default
						 	self.overlays.nur
						 	self.overlays.unstable
						];
					};

					system.tools.darwin-rebuild.enable = false;
				};
			};

			darwinConfigurations = let
				aarch64-darwin = nix-darwin.lib.darwinSystem rec {
				 system = "aarch64-darwin";
				 modules = [
				 	{ nixpkgs.hostPlatform = system; }
				 	home-manager.darwinModules.home-manager
				 	sops-nix.darwinModules.sops
				 	darwinModules.default
				 	./settings/common
				 ];
				};
			in {
				M1Cabuk = aarch64-darwin.extendModules {
					modules = [
						./hosts/M1Cabuk
						./settings/home
					];
				};
				NLLM4000559023 = aarch64-darwin.extendModules {
					modules = [
						./hosts/NLLM4000559023
						./settings/work
					];
				};
			};

			nixConfig = {
				substituters = [
					"https://wwmoraes.cachix.org/"
					"https://nix-community.cachix.org/"
				];
				trusted-public-keys = [
					"wwmoraes.cachix.org-1:N38Kgu19R66Jr62aX5rS466waVzT5p/Paq1g6uFFVyM="
					"nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
				];
			};

			overlays = (import ./overlays) // {
				unstable = final: prev: {
					unstable = import unstable { system = prev.system; };
				};
				nur = final: prev: {
					nur = import nur { pkgs = prev; };
				};
			};
		};

		perSystem = { pkgs, ... }: {
			packages = let
				extraPath = pkgs.lib.makeBinPath (with pkgs; [ coreutils jq git ]);
				nixPath = pkgs.lib.concatStringsSep ":" [
					"darwin-config=/etc/nix-darwin/configuration.nix"
					"/nix/var/nix/profiles/per-user/root/channels"
				];
				path = pkgs.lib.concatStringsSep ":" [
					"${extraPath}"
					"$HOME/.nix-profile/bin"
					"/etc/profiles/per-user/$USER/bin"
					"/run/current-system/sw/bin"
					"/nix/var/nix/profiles/default/bin"
					"/usr/local/bin"
					"/usr/bin"
					"/bin"
					"/usr/sbin"
					"/sbin"
				];
				profile = "/nix/var/nix/profiles/system";
			in rec {
				default = switch-system;
				darwin-rebuild = pkgs.replaceVarsWith rec {
					name = "darwin-rebuild";
					src = ./external/darwin-rebuild.sh;
					dir = "bin";
					isExecutable = true;
					meta.mainProgram = name;
					replacements = {
						inherit path nixPath profile;
						inherit (pkgs.stdenv) shell;
					};
				};
				switch-home = pkgs.writeShellScriptBin "switch-home" ''
					HOSTNAME=$(scutil --get LocalHostName)
					ROOT="''${1:-.}"
					exec nix run $ROOT#darwinConfigurations.$HOSTNAME.config.home-manager.users.$USER.home.activationPackage
				'';
				switch-system = pkgs.writeShellScriptBin "switch-system" ''
					ROOT="''${1:-.}"
					exec sudo nix run .#darwin-rebuild -- switch --no-remote --flake $ROOT
				'';
				## nix-homebrew doesn't export the package, it is added directly to the system packages...
				## builtins.filter (pkg: pkg.name == "brew") darwinConfigurations.M1Cabuk.config.environment.systemPackages
				brew-cleanup = pkgs.writeShellScriptBin "brew-cleanup" ''
					brew update
					brew bundle --cleanup
				'';
			};
		};

		systems = [
			"aarch64-darwin"
			"x86_64-darwin"
		];
	});
}
