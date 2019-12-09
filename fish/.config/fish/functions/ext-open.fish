function ext-open
  type -q open; and open $argv && return
  type -q xdg-open; and xdg-open $argv && return
  echo "there's no open or xdg-open executable on path"
end
