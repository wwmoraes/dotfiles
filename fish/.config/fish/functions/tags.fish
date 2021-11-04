set -q TAGSRC; or set -U TAGSRC $HOME/.tagsrc

function tags -a cmd -d "interact with host tags"
  switch "$cmd"
    case "get" ""
      test -f "$TAGSRC"; or return 0
      cat "$TAGSRC"
    case "set"
      printf "%s\n" $argv[2..-1] | tee "$TAGSRC"
    case "add"
      set -l TAGS (cat "$TAGSRC" (string split " " $argv[2..-1] | psub) | sort | uniq)
      printf "%s\n" $TAGS | tee "$TAGSRC"
      for tag in $argv[2..-1]
        test -f $HOME/.env_$tag
        and dotenv $HOME/.env_$tag
      end
    case "remove"
      set -l REMOVE (string join '|' $argv[2..-1])
      set -l TAGS (grep -vE "^($REMOVE)\$" "$TAGSRC")
      printf "%s\n" $TAGS | tee "$TAGSRC"
      for tag in $argv[2..-1]
        test -f $HOME/.env_$tag
        and dotenv -u $HOME/.env_$tag
      end
    case "contains"
      test (count $argv[2..-1]) -gt 0; or return 2
      test -f "$TAGSRC"; or return 1
      grep -qFx "$argv[2]" "$TAGSRC"
    case "usage" "*"
      echo "usage: tags [get]"
      echo "usage: tags set <tag1>[ <tagN>]"
      echo "usage: tags add <tag1>[ <tagN>]"
      echo "usage: tags remove <tag>"
      echo "usage: tags contains <tag>"
      echo "usage: tags usage"
      test "$cmd" = "usage"; and return 0; or return 2
  end
end

complete -xc tags -n __fish_use_subcommand -a 'get' -d "get current host tags"
complete -xc tags -n '__fish_seen_subcommand_from get'
complete -xc tags -n __fish_use_subcommand -a 'set' -d "replace current host tags"
complete -xc tags -n '__fish_seen_subcommand_from set'
complete -xc tags -n __fish_use_subcommand -a 'add' -d "add tags to the current host"
complete -xc tags -n '__fish_seen_subcommand_from add'
complete -xc tags -n __fish_use_subcommand -a 'remove' -d "remove tags to the current host"
complete -xc tags -n '__fish_seen_subcommand_from remove'
complete -xc tags -n __fish_use_subcommand -a 'contains' -d "check if a tag is set for the current host"
complete -xc tags -n '__fish_seen_subcommand_from contains'
complete -xc tags -n __fish_use_subcommand -a 'usage' -d "tags usage instructions"
complete -xc tags -n '__fish_seen_subcommand_from usage'
