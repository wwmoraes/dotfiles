# TODOs

## Nix

- [ ] modularise darwin-rebuild OR patch upstream
- [ ] flake commands
  - [ ] yubikey card setup
  - [ ] pgp management
  - [x] gpg card switch
- [ ] LS_COLORS
  - <https://github.com/trapd00r/LS_COLORS/blob/master/README.markdown#installation>
  - <https://github.com/sharkdp/lscolors>
- [ ] nix shell integration
  - <https://discourse.nixos.org/t/using-nix-develop-opens-bash-instead-of-zsh/25075/18>
  - <https://github.com/MercuryTechnologies/nix-your-shell>
- [ ] pki: add to keychain and trust
  - `security add-trusted-cert -p ssl -r trustRoot NextDNS.cer`
  - `security dump-trust-settings`
- [ ] git-ps: wrap scripts with extra packages
- [ ] git: global hooks
- [ ] nix: refactor flake registry setup into a separate patch overlay
- [ ] enable htop <https://home-manager.dev/manual/23.05/options.html#opt-programs.htop.enable>
- [ ] try skim <https://home-manager.dev/manual/23.05/options.html#opt-programs.skim.enable>
- [ ] try television <https://home-manager.dev/manual/25.05/options.xhtml#opt-programs.television.enable>
- [ ] configure talos
  - .talos/config
- [ ] configure kubectl
- [ ] flake check: sops keys exist
- [ ] imapfilter module
- [ ] `launchctl config user path`
- [ ] `launchctl config system path`
- [ ] configure nap gist backup
  - `git@gist.github.com:adb2012583db995470a8d4a83b6771b8.git`
  - commit with `git commit --allow-empty-message --no-edit`
- [ ] pet: sync
  - `gh gist edit a868388843ca3e649d17ba243b813830 ~/.config/pet/snippet.toml --filename pet-snippet.toml`
- [ ] try nix-darwin's networking.wg-quick

```fish
## reload all environment variables
exec env \
  --unset __fish_home_manager_config_sourced \
  --unset __HM_SESS_VARS_SOURCED \
  --unset __NIX_DARWIN_SET_ENVIRONMENT_DONE \
  fish
```

## Helix

- [ ] write-good diagnostics <https://github.com/btford/write-good>
- [ ] gopium support <https://github.com/1pkg/gopium>
- [ ] goutline support <https://github.com/1pkg/goutline>
- [ ] gremlins tracker support <https://github.com/nhoizey/vscode-gremlins>
- [ ] prettify JSON
- [ ] prettify YAML
- [ ] licenser support <https://github.com/ymotongpoo/vsc-licenser>
- [ ] readme pattern support <https://github.com/thomascsd/vscode-readme-pattern>
- [ ] TODO tree support <https://github.com/Gruntfuggly/todo-tree>
- [ ] haskell-language-server
- [ ] typos-lsp

## Fish

- [ ] internalise projects new/update commands (currently uses a gist)

## Workflow

- [ ] incorporate Ctrl+R in my workflow (fuzzy history selector)
- [ ] incorporate Ctrl+F in my workflow (fuzzy file selector)
- [ ] incorporate Ctrl+V in my workflow (fuzzy change directory)
- [ ] try ripgrep-all
- [ ] try <https://github.com/eza-community/eza>

## Snippets

```shell
## PGP: list encryption keys of an identity (for gpg --encrypt --recipient)
gpg --list-keys --with-colons "$EMAIL" \
| grep '^sub:\|^fpr:' \
| awk 'BEGIN { FS = ":" } /^sub:u:/ && $12 ~ /e/ { getline; print $10"!" }'
```

```shell
## get current time
date -u +%Y-%m-%dT%H:%M:%SZ
```

```shell
## direnv: dependencies' sizes
nix path-info -sSrh ./.direnv/nix-profile-unknown \
| sort -u \
| awk '{gsub(/\/nix\/store\/[^-]+-/, ""); print $2$3,$1}' \
| sort -hr
```

```shell
## nix: list imperatively installed packages
nix-env --query
# OR
nix profile list
```

```shell
## nix: remove imperatively installed packages
nix-env --uninstall PKG
# OR
nix profile remove PKG
```

```shell
## Resilio Sync: local copy finder
find ~/Cloud/files ~/Cloud/safe -type f \
| grep -vE '.DS_Store|Icon|.*/.sync/.*|\.rsls[a-z]?$'
```

```shell
## Darwin: background tasks control
# file: ~/Library/Application Support/com.apple.backgroundtaskmanagementagent/backgrounditems.btm

## dumps current configuration
sfltool dumpbtm

## resets the background task DB to remove stale items
sfltool resetbtm

## list login items
osascript -e 'tell application "System Events" to get the name of every login \
item'

## remove login item
osascript -e 'tell application "System Events" to delete login item "name"'

## add login item
osascript -e 'tell application "System Events" to make login item at end with \
properties {path:"/Applications/EventScripts.app", hidden:false}'
```

```shell
## darwin: bundle ID extractor
/usr/libexec/PlistBuddy -c 'Print CFBundleIdentifier' Info.plist

## darwin: get GUI apps environment
launchctl print user/(id -u)

## darwin: disable media buttons launching iTunes
launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist
```

```shell
## SSH: shutdown multiplexer control socket
ls ~/.ssh/control/ | fzf -m -0 | ifne cut -d: -f1 | xargs ssh -O stop
```

```shell
## git: enable pushing notes to remote
git config --add remote.origin.push '+refs/notes/*:refs/notes/*'

## git: enable pulling notes from remote
git config --add remote.origin.fetch '+refs/notes/*:refs/notes/*'

## git: push notes to upstream
git push origin 'refs/notes/*'
```

### Work

twistcli-scan:

```shell
#!/usr/bin/env sh
# vim: ft=sh

: "${TWISTLOCK_ADDRESS:=op://Work/Twistlock/website}"
: "${TWISTLOCK_USER=op://Work/Twistlock/username}"
: "${TWISTLOCK_PASSWORD=op://Work/Twistlock/password}"

exec env -i \
  HOME="${HOME}" \
  TWISTLOCK_ADDRESS="${TWISTLOCK_ADDRESS}" \
  TWISTLOCK_USER="${TWISTLOCK_USER}" \
  TWISTLOCK_PASSWORD="${TWISTLOCK_PASSWORD}" \
  op run -- \
  twistcli images scan \
    --address "${TWISTLOCK_ADDRESS}" \
    --publish=false --details "$@"
```

```shell
## retrieve keychain password
security find-internet-password -s "github.com" -a "wwmoraes" -w
## store password in keychain
security add-internet-password -U -s "github.com" -a "wwmoraes" -w "${GITHUB_TOKEN}"
```
