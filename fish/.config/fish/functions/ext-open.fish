function ext-open
  command -q open; and open $argv && return
  command -q xdg-open; and xdg-open $argv && return
  echo "there's no open or xdg-open executable on path"
end
