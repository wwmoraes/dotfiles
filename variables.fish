#!/usr/bin/env fish

# Source the config
test -f ~/.config/fish/config.fish; and source ~/.config/fish/config.fish

for entry in (cat .env | grep -v '^#' | grep -v '^$')
  set entry = (string split \= -- $entry)
  set key $entry[2]
  set value (echo $entry[3..-1])

  echo Setting (set_color brcyan)$key(set_color normal)

  set -U $key $value
  set -eg $key
end

### Add user paths to fish if they're not set already
for user_path in (string split ':' $argv[1])
  if not contains $user_path $fish_user_paths && string match -q "/home/*" $user_path
    echo "adding $user_path to fish user paths..."
    set -U fish_user_paths $user_path $fish_user_paths
  end
end

# Remove the global version, as it shadows the universal one
set -eg fish_user_paths
