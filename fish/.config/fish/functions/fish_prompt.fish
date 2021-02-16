function __fish_preexec_wakatime --on-event fish_preexec
  set -l languageName ""
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

    # replace folder navigation to cd command
    test -d $commandName; and set -l commandName "cd"
    # ignore if not a valid command
    type -p "$commandName" > /dev/null ^&1; or return

    ### language overrides
    # fish abbreviations
    abbr -l | grep -qx $commandName; and set languageName "fish"
    # fish functions
    functions -n | tr ',' '\n' | grep -x $commandName; and set languageName "fish"
    # shell scripts
    string match -r "\.fish\$" $commandName; and set languageName "fish"
    string match -r "\.sh\$" $commandName; and set languageName "shell"

    wakatime \
      --write \
      --plugin "fish-wakatime/0.0.1" \
      --entity-type app \
      --language "$languageName" \
      --project "$projectName" \
      --entity "$commandName" 2>&1 >/dev/null &
    disown (jobs -lp | tail +1) 2>/dev/null
  end
end
