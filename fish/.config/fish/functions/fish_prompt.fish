function fish_prompt
  set -l last_status $status

  # try to use powerline-go
  type -p "go" > /dev/null 2>&1; and begin
    set -q GOPATH; or set -l GOPATH (go env GOPATH)
    test -x "$GOPATH/bin/powerline-go"; and begin
      "$GOPATH/bin/powerline-go" \
        -error $last_status \
        -jobs (count (jobs -p)) \
        -modules "venv,user,host,ssh,cwd,perms,jobs,exit,root" \
        -numeric-exit-codes \
        -shell bare \
        -hostname-only-if-ssh
      return
    end
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
  set -l prompt_status (__fish_print_pipestatus " [" "]" "|" (set_color $fish_color_status) (set_color --bold $fish_color_status) $last_status)

  echo -n -s (set_color $fish_color_user) "$USER" $normal @ (set_color $color_host) (prompt_hostname) $normal ' ' (set_color $color_cwd) (prompt_pwd) $normal (fish_vcs_prompt) $normal $prompt_status $suffix " "
end
