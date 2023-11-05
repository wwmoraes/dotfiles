set -q KITTY_INSTALLATION_DIR; or exit

set -g KITTY_SHELL_INTEGRATION enabled
source "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_conf.d/kitty-shell-integration.fish"
set --prepend fish_complete_path "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_completions.d"
