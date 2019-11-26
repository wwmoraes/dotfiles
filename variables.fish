#!/usr/bin/env fish

## Main
# Source the config
test -f ~/.config/fish/config.fish; and source ~/.config/fish/config.fish

# Set environment variables
dotenv "~/.env"
dotenv "~/.env_secrets"
isPersonal; and begin
  dotenv "~/.env_personal"
  dotenv "~/.env_personal_secrets"
end
isWork; and begin
  dotenv "~/.env_work"
  dotenv "~/.env_work_secrets"
end

# dedup args
set -l argv[1] (echo -n $argv[1] | awk '{gsub(/\/$/,"")} !($0 in a) {a[$0]; printf("%s%s", length(a) > 1 ? ":" : "", $0)}')

### Add user paths to fish
echo "Setting fish user paths..."
for user_path in (string split ':' $argv[1] | sed 's|/$||g')[-1..1]
  if test -d "$user_path" \
    && string match -q (string replace "/$USER" "/*" $HOME) $user_path
    echo adding/keeping (set_color brmagenta)$user_path(set_color normal)
    set -U fish_user_paths $user_path $fish_user_paths
  end
end

### Cleanup of paths (done separately so the user paths order are kept)
for user_path in $fish_user_paths
  # duplicates
  set -l indices (echo -e (string join "\n" $fish_user_paths) | \
                  sed 's|/$||g' | nl | grep $user_path | \
                  tail -n+2 | \
                  awk '{$1=$1};1' | \
                  cut -d' ' -f1 | \
                  sort -r)

  for indice in $indices
    set -eU fish_user_paths[$indice]
  end

  # non-existent
  if test ! -d "$user_path"
    printf "path (set_color brmagenta)$user_path(set_color normal) does not exist. Removing from user paths...\n"
    set -eU fish_user_paths[(contains -i $user_path $fish_user_paths)]
  end
end

# Remove old environment variables
for entry in (cat .env-remove | grep -v '^#' | grep -v '^$')
  if set -q $entry
    echo Unsetting (set_color brcyan)$entry(set_color normal)
    eval "set -e $entry"
  end
end

# Remove the global version, as it shadows the universal one
set -eg fish_user_paths
