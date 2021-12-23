function __fish_preexec_wakatime --on-event fish_preexec
  set -l languageName ""
  set -l projectName "terminal"

  test -d $PWD/.git; and begin
    if not test -f $PWD/.wakatime-project
      project > $PWD/.wakatime-project
    end
    set projectName (cat $PWD/.wakatime-project)
  end

  type -p wakatime > /dev/null ^&1; or return

  test -z "$argv"; and return

  set -l commandName (string split ' ' $argv[1])[1]

  ### command name transformations
  # replace folder navigation with cd command
  test -d $commandName; and set -l commandName "cd"
  # ignore if not a valid command
  type -p "$commandName" > /dev/null ^&1; or return

  ### project overrides
  # change the project to terminal if it is a builtin command
  builtin -n | grep -qx $commandName; and set projectName "terminal"
  test "$commandName" = "dotfiles"; and set projectName "wwmoraes/dotfiles"
  test "$commandName" = "dotsecrets"; and set projectName "wwmoraes/dotsecrets"

  ### language overrides
  # fish abbreviations
  abbr -l | grep -qx $commandName; and set languageName "fish"
  # fish functions
  functions -n | tr ',' '\n' | grep -qx $commandName; and set languageName "fish"
  # shell scripts
  string match -qr "\.fish\$" $commandName; and set languageName "fish"
  string match -qr "\.sh\$" $commandName; and set languageName "shell"

  wakatime \
    --write \
    --plugin "fish-wakatime/0.0.1" \
    --entity-type app \
    --language "$languageName" \
    --project "$projectName" \
    --entity "$commandName" 2>&1 >/dev/null &
  disown (jobs -lp | tail +1) 2>/dev/null
end

function fish_prompt
  set -l error $status
  set -q GOPATH; or set -l GOPATH (go env GOPATH)
  eval $GOPATH/bin/powerline-go -error $error -jobs (count (jobs -p))
end
