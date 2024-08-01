command -q aws; or exit

function __fish_complete_aws
    env COMP_LINE=(commandline -pc) aws_completer | tr -d ' '
end

complete -c aws -f -a "(__fish_complete_aws)"
