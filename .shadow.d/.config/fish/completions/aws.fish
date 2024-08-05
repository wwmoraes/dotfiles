command -q aws; or exit

complete -ec aws

function __fish_complete_aws
  command -q aws_completer; or return

  env COMP_LINE=(commandline -pc) aws_completer | tr -d ' '
end

complete -c aws -f -a "(__fish_complete_aws)"
