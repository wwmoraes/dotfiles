# Remove the global version, as it shadows the universal one
set -eg fish_user_paths

pgpz unlock > /dev/null &

# source ~/.config/fish/functions/fish_prompt.fish &

# try to launch tmux
launch-tmux
