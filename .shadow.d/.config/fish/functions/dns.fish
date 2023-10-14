function dns -d "Compact DNS results"
    if test (count $argv) = 0
        echo "Missing required argument: hostname"
        return 1
    end

    set -q $argv[2]; and set entryType ANY; or set entryType $argv[2]

    echo dig +nocmd (domain $argv[1]) $entryType +multiline +noall +answer
    dig +nocmd (domain $argv[1]) $entryType +multiline +noall +answer
end
