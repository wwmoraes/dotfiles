function dotenv -d '"Sources" (set universal and exports) variables from given dotenv file, if it exists'
  if test (count $argv) = 0
    set -a argv ~/.env
    for tag in (tags get)
      set -a argv ~/.env_$tag
      set -a argv ~/.env_{$tag}_secrets
    end
  end

  for filePath in $argv
    if not test -f $filePath
      echo Error: file $filePath does not exist or can not be read
      continue
    end

    echo Parsing dotenv file $filePath

    for entry in (cat $filePath | grep -v '^#' | grep -v '^$')
      set entry (echo -e $entry | string trim -c '-' | string split -m 1 \=)
      set key $entry[1]

      set value (echo -e $entry[2] | string trim -c "'" | tr '\0' '\n' | sed "s|~|$HOME|g")

      echo Setting (set_color brcyan)$key(set_color normal)

      set -eg $key
      set -Ux $key $value
    end
  end

  for filePath in ~/.env_remove*
    while read -l variable
      set -q $variable; or continue
      echo Removing (set_color brcyan)$variable(set_color normal)
      set -eg $variable
      set -eU $variable
    end < (cat "$filePath" | grep -v '^#' | grep -v '^$' | psub)
  end

  return 0
end
