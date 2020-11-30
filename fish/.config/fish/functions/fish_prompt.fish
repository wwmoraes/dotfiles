function __fish_preexec_wakatime --on-event fish_preexec
  set -l project "terminal"

  test -d $PWD/.git
  and begin
    if not test -f $PWD/.wakatime-project
      set project (git -C $PWD remote get-url (git -C $PWD remote | head -1) 2> /dev/null)
      set project (string replace -r "git@(.*):(.*)\.git" "\$1/\$2" $project)
      echo $project >$PWD/.wakatime-project
    else
      set project (cat $PWD/.wakatime-project)
    end
  end

  test -n "$argv"
  and begin
    wakatime \
      --write \
      --plugin "fish-wakatime/0.0.1" \
      --entity-type app \
      --project "$project" \
      --entity "(echo $argv | cut -d ' ' -f1)" 2>&1 >/dev/null &
    disown (jobs -lp | tail +1)
  end
end
