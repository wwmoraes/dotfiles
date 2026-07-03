define FILES_SOURCES
$(sort $(strip
$(shell git grep --name-only --untracked 'files.file' -- '*.nix')
))
endef
define FILES_OUTPUTS
$(sort $(strip
.github/workflows/integration.yml
))
endef

.PHONY: files
#: Re-generates files managed by nix.
files: flake.nix ${FILES_OUTPUTS}

${FILES_OUTPUTS} &: $(filter-out ${FILES_OUTPUTS},${FILES_SOURCES})
	@git add -N $^
	nix run .#write-files
	@touch ${FILES_OUTPUTS}

flake.nix: $(filter-out flake.nix,$(shell git grep --name-only --untracked 'flake-file' -- '*.nix'))
	@git add -N $^
	nix run .#write-flake
	@touch $@
