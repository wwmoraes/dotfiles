function __fish_preexec_wakatime --on-event fish_preexec
  set -l languageName ""
  set -l projectName "terminal"

  test -d $PWD/.git; and begin
    if not test -f $PWD/.wakatime-project
      project > $PWD/.wakatime-project
    end
    set projectName (cat $PWD/.wakatime-project)
  end

  type -p wakatime > /dev/null 2>&1; or return

  test -z "$argv"; and return

  set -l commandName (string split ' ' $argv[1])[1]

  ### command name transformations
  # replace folder navigation with cd command
  test -d $commandName; and set -l commandName "cd"
  # ignore if not a valid command
  type -p "$commandName" > /dev/null 2>&1; or return

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
  set -l last_pipestatus $pipestatus

  # try to use powerline-go
  set -q GOPATH; or set -l GOPATH (go env GOPATH)
  test -x "$GOPATH/bin/powerline-go"; and begin
    eval "$GOPATH/bin/powerline-go" -error $last_pipestatus -jobs (count (jobs -p))
    return
  end

  # almost vanilla from https://github.com/fish-shell/fish-shell/blob/3.1.2/share/functions/fish_prompt.fish
  set -l normal (set_color normal)

  # Color the prompt differently when we're root
  set -l color_cwd $fish_color_cwd
  set -l prefix
  set -l suffix '>'
  if contains -- $USER root toor
      if set -q fish_color_cwd_root
          set color_cwd $fish_color_cwd_root
      end
      set suffix '#'
  end

  # If we're running via SSH, change the host color.
  set -l color_host $fish_color_host
  if set -q SSH_TTY
      set color_host $fish_color_host_remote
  end

  # Write pipestatus
  set -l prompt_status (__fish_print_pipestatus " [" "]" "|" (set_color $fish_color_status) (set_color --bold $fish_color_status) $last_pipestatus)

  echo -n -s (set_color $fish_color_user) "$USER" $normal @ (set_color $color_host) (prompt_hostname) $normal ' ' (set_color $color_cwd) (prompt_pwd) $normal (fish_vcs_prompt) $normal $prompt_status $suffix " "
end
