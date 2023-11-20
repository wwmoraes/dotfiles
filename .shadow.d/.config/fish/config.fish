# Remove the global version, as it shadows the universal one
set -eg fish_user_paths
set -eg SSH_AUTH_SOCK

# try to launch tmux
launch-tmux
