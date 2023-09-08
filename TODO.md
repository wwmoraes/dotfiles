# TO DO

- [ ] path management
- [ ] MacOS: use `/etc/paths.d`, `/etc/manpaths.d` + `/usr/libexec/path_helper -s`
- [ ] add setup folder per tag + install based on tags
- [ ] fix casks that only work on `/Applications`
  - `1password`
  - `megasync`
  - `duet`
  - `little-snitch`
- [ ] remove quarantine from installed bundles `xattr -rd com.apple.quarantine <path>`
- [ ] add touch ID support for sudo
  - file `/etc/pam.d/sudo`
  - entry: `auth sufficient pam_tid.so`

## miscellaneous commands

- random generator
  `env LC_ALL=C tr -dc A-Za-z0-9_- </dev/urandom | head -c 256 ; echo ''`

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

## container commands

list effective capabilities

```sh
apk update && apk add --quiet --no-cache libcap
capsh --decode=$(grep Cap /proc/1/status | grep CapEff | cut -d':' -f2 | xargs) | cut -d'=' -f2 | tr ',' '\n'
```

## Git hooks templates

- <https://github.com/greg0ire/git_template>
- <http://git-scm.com/docs/githooks>
- <http://git-scm.com/docs/git-init#_template_directory>
