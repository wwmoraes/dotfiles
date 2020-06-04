function domain -d "extract domain from a given URL"
    set -l parts (string split / -- (string replace -r "^[a-z]+://" "" $argv[1]))
    set -l domain $parts[1]

    if test -z "$domain"
        set domain $argv[1]
    end

    echo (string replace www. '' $domain)
end
