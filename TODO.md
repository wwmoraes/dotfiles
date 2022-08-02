# TO DO

- [ ] add setup folder per tag + install based on tags

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

## sudoers settings

```sudoers
# homebrew
%staff ALL = NOPASSWD:SETENV: /bin/mkdir -p /Application
%staff ALL = NOPASSWD:SETENV: /bin/mv /usr/local/Caskroom/*.app /Applications/*.app
```

## Git hooks templates

- <https://github.com/greg0ire/git_template>
- <http://git-scm.com/docs/githooks>
- <http://git-scm.com/docs/git-init#_template_directory>
