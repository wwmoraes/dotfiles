set --local temp_values

for value in $argv
    contains $value $temp_values; and continue

    set --append temp_values $value
end

printf "%s\n" $temp_values
