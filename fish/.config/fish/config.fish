# Remove the global version, as it shadows the universal one
set -eg fish_user_paths

# manual kitty integration
if set -q KITTY_INSTALLATION_DIR
  set --global KITTY_SHELL_INTEGRATION enabled
  source "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_conf.d/kitty-shell-integration.fish"
  set --prepend fish_complete_path "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_completions.d"
end

# manual code integration
set -l CODE (command -v code | command -v code-oss | command -v codium)
string match -q "$TERM_PROGRAM" "vscode"
and . ($CODE --locate-shell-integration-path fish)

# try to launch tmux
launch-tmux

source ~/.config/fish/functions/fish_prompt.fish
