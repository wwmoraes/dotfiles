ifeq (${HOSTNAME},${WORK_HOSTNAME})
# Fetches the latest visudo derivation from the binary cache.
#
# In practice this isn't needed as nix does check the substituters first before
# trying to build from source.
#
# Sometimes I forget/CI takes a while to push a binary cache update before
# trying to re-apply the configuration @ work; this leads to a situation
# where the substitution fails, caching that result for hours before trying to
# build from source. Since my work environment does not allow connections to
# https://git.sudo.ws, I cannot build from source; thus it ends in a soft-locked
# state for the duration of that cache to retry the substitution again.
#
# This brute-force option restores the store path from the binary cache
# directly, which nix detects and skips the source build.
work-visudo: OUT=$(shell nix eval --raw .#darwinConfigurations.${WORK_HOSTNAME}.pkgs.nur.repos.wwmoraes.visudo.outPath)
work-visudo: NARHASH=$(firstword $(subst -, ,$(notdir ${OUT})))
#: Out-of-band visudo package handling. Necessary in dumb corporate environments. Pulls package from cache. Builds when ran on any other host.
work-visudo:
	curl -fsSLo - https://wwmoraes.cachix.org/${NARHASH}.narinfo \
	| grep '^URL:' \
	| cut -d' ' -f2 \
	| xargs -I% curl -fsSLo - https://wwmoraes.cachix.org/% \
	| zstdcat \
	| nix-store --restore '${OUT}'
	; nix-store --repair-path '${OUT}'
else
ifneq ($(shell which op),)
OP = op plugin run --
else
OP =
endif

work-visudo: OUT=$(shell nix eval --raw .#darwinConfigurations.${WORK_HOSTNAME}.pkgs.nur.repos.wwmoraes.visudo.outPath)
work-visudo: NARHASH=$(firstword $(subst -, ,$(notdir ${OUT})))
#: Out-of-band visudo package handling. Necessary in dumb corporate environments. Builds and pushes to cache. Pulls when ran in the work host.
work-visudo:
	nom build --no-link --accept-flake-config --print-out-paths .#darwinConfigurations.${WORK_HOSTNAME}.pkgs.nur.repos.wwmoraes.visudo | ${OP} cachix push wwmoraes
endif
