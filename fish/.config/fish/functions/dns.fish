function dns -d "Compact DNS results"
    if test (count $argv) = 0
        echo "Missing required argument: hostname"
        return 1
    end

    dig +nocmd (domain $argv[1]) any +multiline +noall +answer
end

function domain -d "extract domain from a given URL"
    set -l parts (string split / -- (string replace -r "^[a-z]+://" "" $argv[1]))
    set -l domain $parts[1]

    if test -z "$domain"
        domain=$argv[1]
    end

    echo (string replace www. '' $domain)
end
