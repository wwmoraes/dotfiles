#!/usr/bin/env fish

# Source the config
test -f ~/.config/fish/config.fish; and source ~/.config/fish/config.fish

### Add user paths to fish if they're not set already
for user_path in (string split ':' $argv[1])
  if not contains $user_path $fish_user_paths && string match -q "/home/*" $user_path
    echo "adding $user_path to fish user paths..."
    set -U fish_user_paths $user_path $fish_user_paths
  end
end

# Remove the global version, as it shadows the universal one
set -eg fish_user_paths
