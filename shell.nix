{ system ? builtins.currentSystem
, sources ? import ./nix/sources.nix
}: let
	pkgs = import sources.nixpkgs {
		inherit system;
		config.packageOverrides = pkgs: {
			nur = import sources.NUR { inherit pkgs; };
			unstable = import sources.unstable { inherit system pkgs; };
		};
	};
	inherit (pkgs) mkShell;
in mkShell {
	packages = [
		pkgs.bash
		pkgs.chezmoi
		pkgs.delta
		pkgs.editorconfig-checker
		pkgs.fish
		pkgs.gitleaks
		pkgs.go-task
		pkgs.gron
		pkgs.jq
		pkgs.lefthook
		pkgs.markdownlint-cli
		pkgs.nur.repos.wwmoraes.ejson
		pkgs.nur.repos.wwmoraes.go-commitlint
		pkgs.shellcheck
		pkgs.sops
		pkgs.unstable.git
		pkgs.unstable.lazygit
		pkgs.yamllint
		pkgs.yq-go
	];
}
