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

secrets: .ejson/secrets.json .ejson/keys/6bf53a356a4b8abbc9a41ae2912787e56853e211653bb23d5da4a87ba6c9df6f
	$(info encrypting payload $<)
	@ejson encrypt $<
	@op document edit "ejson payload" $< || true

debug-secrets:
	@gron .ejson/secrets.tmpl.json | grep "op://" | sed 's/[";]//g' | xargs -P 0 -I% bash -c 'echo "%" | op inject > /dev/null || echo %'

.ejson/secrets.json: .ejson/secrets.tmpl.json
	$(info injecting secrets from 1Password)
	@op inject -f -i $< -o $@

.ejson/keys/6bf53a356a4b8abbc9a41ae2912787e56853e211653bb23d5da4a87ba6c9df6f:
	$(info generating private key)
	@op read --no-newline "op://Personal/ejson/password" > $@
