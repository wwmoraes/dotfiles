SHELL := /usr/bin/env bash

REPOSITORY_FILES = find ${PWD} \
	-not -path '*/.git/*' \
	-not -path '*/.tmp/*' \
	-not -path '*/fish/*bass*' \
	-not -path '*/fish/*fzf*' \
	-not -path '*/fish/completions/kubectl*' \
	-not -path '*/fish/*nvm*' \
	-not -path '*/.DS_Store' \
	-type f \
	| sed "s|${PWD}/||g" \
	| sort -u

CONTEXT_FILES = jq -r '.contexts | to_entries | .[].value[]' .vscode/contexts.json | sort -u

.PHONY: context
context:
	@comm -23 <(${REPOSITORY_FILES}) <(${CONTEXT_FILES})
