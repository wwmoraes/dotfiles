function dotenv -a filePath -d '"Sources" (set universal and exports) variables from given dotenv file, if it exists'
  if not test -f $filePath
    echo Error: file $filePath does not exist or can not be read
    return
  end

  echo Parsing dotenv file $filePath

  for entry in (cat $filePath | grep -v '^#' | grep -v '^$')
    set entry = (string split -m 1 \= -- $entry)
    set key $entry[2]
    set value (echo -e $entry[3] | string trim -c "'" | tr '\0' '\n' | sed "s|~|$HOME|g")

    echo Setting (set_color brcyan)$key(set_color normal)

    set -e $key
    set -U $key $value
  end
end
