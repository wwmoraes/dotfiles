define FILES_SOURCES
$(sort $(strip
$(shell git grep --name-only --untracked 'flake-file' -- '*.nix')
$(shell git grep --name-only --untracked 'files.files' -- '*.nix')
))
endef
define FILES_OUTPUTS
$(sort $(strip
.github/workflows/integration.yml
flake.nix
))
endef

.PHONY: files
#: Re-generates files managed by nix.
files: ${FILES_OUTPUTS}

${FILES_OUTPUTS} &: $(filter-out ${FILES_OUTPUTS},${FILES_SOURCES})
	@$(if $?,git add -N $(sort $?),:)
	nix run .#write-files
	@touch ${FILES_OUTPUTS}
