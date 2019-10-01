# Remove the global version, as it shadows the universal one
set -eg fish_user_paths

if status is-interactive
and not set -q TMUX
    exec tmux new -A -s main
end
