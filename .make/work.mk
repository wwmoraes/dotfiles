ifeq (${HOSTNAME},NLLM4000559023)
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
work-fetch-visudo: OUT=$(shell nix eval --raw .#darwinConfigurations.${HOSTNAME}.pkgs.nur.repos.wwmoraes.visudo.outPath)
work-fetch-visudo: NARHASH=$(firstword $(subst -, ,$(notdir ${OUT})))
work-fetch-visudo:
	curl -fsSLo - https://wwmoraes.cachix.org/${NARHASH}.narinfo \
	| grep '^URL:' \
	| cut -d' ' -f2 \
	| xargs -I% curl -fsSLo - https://wwmoraes.cachix.org/% \
	| zstdcat \
	| nix-store --restore '${OUT}'
endif
