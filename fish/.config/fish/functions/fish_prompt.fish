function __fish_preexec_wakatime --on-event fish_preexec
  set -l projectName "terminal"

  test -d $PWD/.git
  and begin
    if not test -f $PWD/.wakatime-project
      project > $PWD/.wakatime-project
    end
    set projectName (cat $PWD/.wakatime-project)
  end

  test -n "$argv"
  and begin
    set -l commandName (echo "$argv" | cut -d ' ' -f1)
    wakatime \
      --write \
      --plugin "fish-wakatime/0.0.1" \
      --entity-type app \
      --project "$projectName" \
      --entity "$commandName" 2>&1 >/dev/null &
    disown (jobs -lp | tail +1) 2>/dev/null
  end
end
