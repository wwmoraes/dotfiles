function domain -d "extract domain from a given URL"
    set -l domain (string replace -r "^(?:[a-z]+://)?([^:]+)(?::[0-9]+)?\$" "\$1" $argv[1])

    echo (string replace www. '' $domain)
end
