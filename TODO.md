# To-dos

- [ ] `chezmoi init` as bootstrap
  - <https://www.chezmoi.io/user-guide/advanced/install-your-password-manager-on-init/>
- [ ] configure ADR to use MADR template
- [ ] bundle ID extractor
  - `/usr/libexec/PlistBuddy -c 'Print CFBundleIdentifier' Info.plist`
- [ ] set GUI apps environment
  - `launchctl print user/(id -u)`

## Snippets

### direnv nix dependencies' sizes

```shell
nix path-info -sSrh ./.direnv/nix-profile-unknown \
| sort -u \
| awk '{gsub(/\/nix\/store\/[^-]+-/, ""); print $2$3,$1}' \
| sort -hr
```

## Helix/Zellij

- [ ] write-good diagnostics <https://github.com/btford/write-good>
- [ ] gopium support <https://github.com/1pkg/gopium>
- [ ] goutline support <https://github.com/1pkg/goutline>
- [ ] gremlins tracker support <https://github.com/nhoizey/vscode-gremlins>
- [ ] prettify JSON
- [ ] prettify YAML
- [ ] licenser support <https://github.com/ymotongpoo/vsc-licenser>
- [x] regal rego language server support
- [ ] readme pattern support <https://github.com/thomascsd/vscode-readme-pattern>
- [ ] TODO tree support <https://github.com/Gruntfuggly/todo-tree>
- [ ] MacOS hostname set
  - `scutil --set ComputerName <new name>`
  - `scutil --set HostName <new host name>`
  - `scutil --set LocalHostName <new host name>`
- [ ] Resilio Sync local copy finder
  - `find ~/Cloud/files ~/Cloud/safe -type f | grep -vE '.DS_Store|Icon|.*/.sync/.*|\.rsls[a-z]?$'`
- [ ] background tasks control
  - `~/Library/Application Support/com.apple.backgroundtaskmanagementagent/backgrounditems.btm`
  - `sfltool dumpbtm`
  - list: `osascript -e 'tell application "System Events" to get the name of
    every login item'`
  - remove: `osascript -e 'tell application "System Events" to delete login
    item "name"'`
  - add: `osascript -e 'tell application "System Events" to make login item at
    end with properties {path:"/Applications/EventScripts.app", hidden:false}'`

## Road to nix refactoring

- [ ] `launchctl config user path`
- [ ] `launchctl config system path`
- [ ] nix: manage fine-tuning (defaults script)
- [ ] nix: manage sudoers
- [ ] nix: manage termcap
- [ ] nix: manage group membership
