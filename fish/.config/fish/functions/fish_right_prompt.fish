function fish_right_prompt
  # must be on a git directory
  git rev-parse --is-inside-work-tree >/dev/null 2>&1; or return
  # try to use powerline-go
  type -p "go" > /dev/null 2>&1; or return
  set -q GOPATH; or set -l GOPATH (go env GOPATH)
  test -x "$GOPATH/bin/powerline-go"; or return

  set -l background "303030"
  set -l normal (set_color -b $background normal)
  set -l segments

  set -l unmerged (git ls-files --unmerged --exclude-standard | wc -l | xargs)
  test $unmerged -gt 0 && set -l -a segments (set_color -b $background brred)"✗ $unmerged$normal"

  set -l untracked (git ls-files --others --exclude-standard | wc -l | xargs)
  test $untracked -gt 0 && set -l -a segments (set_color -b $background brmagenta)"+ $untracked$normal"

  set -l modified (git ls-files --modified --exclude-standard | wc -l | xargs)
  test $modified -gt 0 && set -l -a segments (set_color -b $background bryellow)"✎ $modified$normal"

  set -l staged (git diff --name-only --cached | wc -l | xargs)
  test $staged -gt 0 && set -l -a segments (set_color -b $background brgreen)"✔ $staged$normal"

  set -l stashed (git stash list | wc -l | xargs)
  test $stashed -gt 0 && set -l -a segments (set_color -b $background brcyan)"❄ $stashed$normal"

  set -l remote (git remote)
  set -l branch (git branch --show-current)

  set -l revCount (git rev-list --left-right --count $remote/$branch...$branch 2>/dev/null)
  and begin
    echo $revCount | xargs | read -l behind ahead
    set -l aheadbehind brgreen
    test $ahead -gt 0 -o $behind -gt 0; and set -l aheadbehind bryellow
    set -l -a segments (set_color -b $background $aheadbehind)"↑$ahead↓$behind$normal"
  end

  set -l -a segments " "$branch
  set -l separator (set_color -b $background 626262)"  "$normal
  printf "%s%s %s %s" (set_color $background) $normal (string join $separator $segments) (set_color normal)
end
