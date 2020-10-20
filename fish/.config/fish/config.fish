# Remove the global version, as it shadows the universal one
set -eg fish_user_paths

# try to launch tmux
launch-tmux

source ~/.config/fish/functions/fish_prompt.fish
