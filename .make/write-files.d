# add write-files outputs to the porcelain files target
files: .github/workflows/integration.yml
files: .make/50-darwin.gen.mk
files: .make/50-home.gen.mk
files: .make/50-nixos.gen.mk

# files' dependencies
.github/workflows/integration.yml: modules/files/github-workflows.nix
.make/50-darwin.gen.mk: modules/files/make/darwin.nix
.make/50-home.gen.mk: modules/files/make/home.nix
.make/50-nixos.gen.mk: modules/files/make/nixos.nix

# files' recipe
.github/workflows/integration.yml .make/50-darwin.gen.mk .make/50-home.gen.mk .make/50-nixos.gen.mk &:
	nix run .#write-files
	@touch .github/workflows/integration.yml .make/50-darwin.gen.mk .make/50-home.gen.mk .make/50-nixos.gen.mk
