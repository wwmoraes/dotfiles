function dotenv -a filePath -d '"Sources" (set universal and exports) variables from given dotenv file, if it exists'
  test -f $filePath; or return

  echo Parsing dotenv file $filePath

  for entry in (cat $filePath | grep -v '^#' | grep -v '^$')
    set entry = (string split \= -- $entry)
    set key $entry[2]
    set value (echo $entry[3..-1])

    echo Setting (set_color brcyan)$key(set_color normal)

    set -eg $key
    set -Ux $key $value
  end
end
