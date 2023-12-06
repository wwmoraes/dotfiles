# Remove the global version, as it shadows the universal one
set -eg fish_user_paths
set -eg SSH_AUTH_SOCK

# safely erase the inherited global PATH and use the universal one
set -qU PATH; and set -eg PATH

# try to launch tmux
launch-tmux
