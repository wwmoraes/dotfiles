functions -e fish_right_prompt
# function fish_right_prompt
#   # must be on a git directory
#   git rev-parse --is-inside-work-tree >/dev/null 2>&1; or return

#   function right_segment -a color content
#     echo -en (set_color $color)""(set_color -b $color normal)$content
#   end

#   set -l reset (set_color -b normal normal)
#   set -l segments

#   set -l unmerged (git ls-files --unmerged --exclude-standard | wc -l | xargs)
#   test $unmerged -gt 0 && set -l -a segments (right_segment B71C1C " ✗ $unmerged")

#   set -l modified (git ls-files --modified --exclude-standard | wc -l | xargs)
#   test $modified -gt 0 && set -l -a segments (right_segment E64A19 " ✎ $modified")

#   set -l untracked (git ls-files --others --exclude-standard | wc -l | xargs)
#   test $untracked -gt 0 && set -l -a segments (right_segment 4A148C " + $untracked")

#   set -l staged (git diff --name-only --cached | wc -l | xargs)
#   test $staged -gt 0 && set -l -a segments (right_segment 1B5E20 " ✔ $staged")

#   set -l stashed (git stash list | wc -l | xargs)
#   test $stashed -gt 0 && set -l -a segments (right_segment 0000E0 " ❄ $stashed")

#   # ahead-behind counter segment
#   set -l remote (git remote)
#   set -l branch (git branch --show-current)

#   set -l revCount (git rev-list --left-right --count $remote/$branch...$branch 2>/dev/null)
#   echo $revCount | xargs | read -l behind ahead
#   set -l -a segments (right_segment 455A64 " ↑ $ahead ↓ $behind")

#   # branch segment
#   set -l -a segments (right_segment AD1457 "  $branch")

#   printf "%s%s%s" $reset (string join " " $segments) " " $reset
# end
