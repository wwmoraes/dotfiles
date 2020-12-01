# TO DO

## transform into function

```shell
# fuzzy removes array elements
echo -e (string join "\n" $fish_user_paths) | \
  nl | \
  cat (echo "INDEX PATH" | psub) - | \
  column -t | \
  fzf -m --header-lines=1 --prompt="which element(s) do you want to remove? " | \
  awk '{print $1}' | ifne xargs -I {} fish -c "set -eU fish_user_paths[{}]"
```
