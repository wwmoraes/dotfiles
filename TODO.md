# To-dos

- [x] refactor fish variables script
- [x] move fisher bootstrap to externals
- [ ] configure ADR to use MADR template
- [ ] bundle ID extractor
  - `/usr/libexec/PlistBuddy -c 'Print CFBundleIdentifier' Info.plist`
- [ ] set GUI apps environment
  - `launchctl print user/(id -u)`
- `nix path-info -sSrh ./.direnv/nix-profile-unknown | sort -u | awk '{gsub(/\/nix\/store\/[^-]+-/, ""); print $2$3,$1}' | sort -hr`

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
