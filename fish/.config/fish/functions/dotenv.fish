function dotenv -d '"Sources" (set universal and exports) variables from given dotenv file, if it exists'
  argparse 'u/unset' -- $argv; or return

  if test (count $argv) = 0
    set -a argv $HOME/.env $HOME/.env_secrets
    for tag in (tags get)
      test -f $HOME/.env_$tag
      and set -a argv $HOME/.env_$tag
      test -f $HOME/.env_{$tag}_secrets
      and set -a argv $HOME/.env_{$tag}_secrets
    end
  end

  for filePath in $HOME/.env_remove*
    echo "Parsing "(set_color brmagenta)$filePath(set_color normal)
    while read -l variable
      echo "Removing "(set_color brcyan)$variable(set_color normal)
      set -eg $variable
      set -eU $variable
      launchctl unsetenv $variable
    end < (cat "$filePath" | grep -v '^#' | grep -v '^$' | psub)
  end

  for filePath in $argv
    if not test -f $filePath
      echo "Error: file $filePath does not exist or can not be read"
      continue
    end

    echo "Parsing "(set_color brmagenta)$filePath(set_color normal)

    for entry in (cat $filePath | grep -v '^#' | grep -v '^$')
      set entry (echo -e $entry | string trim -c '-' | string split -m 1 \=)
      set key $entry[1]

      set value (echo -e $entry[2] | string trim -c "'" | tr '\0' '\n' | sed "s|~|$HOME|g")

      if string match -q "*_secrets" $filePath
        set clearFlags "-eU"
        set defineFlags "-gx"
      else
        set clearFlags "-eg"
        set defineFlags "-Ux"
      end

      set -eg $key
      if string length -q -- $_flag_unset
        echo "Unsetting "(set_color brcyan)$key(set_color normal)
        set -eg $key
        set -eU $key
        launchctl unsetenv $key
      else
        echo "Setting "(set_color brcyan)$key(set_color normal)
        set $clearFlags $key
        set $defineFlags $key $value
        launchctl setenv $key $value
      end
    end
  end

  return 0
end
