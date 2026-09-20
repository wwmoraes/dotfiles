files: .github/workflows/integration.yml .make/50-darwin.gen.mk .make/50-home.gen.mk .make/50-nixos.gen.mk .make/80-install.gen.mk
.github/workflows/integration.yml .make/50-darwin.gen.mk .make/50-home.gen.mk .make/50-nixos.gen.mk .make/80-install.gen.mk &: modules/files/github-workflows.nix modules/files/make.nix
	nix run .#write-files
	@touch .github/workflows/integration.yml .make/50-darwin.gen.mk .make/50-home.gen.mk .make/50-nixos.gen.mk .make/80-install.gen.mk
