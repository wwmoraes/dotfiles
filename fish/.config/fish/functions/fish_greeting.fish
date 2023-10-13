command -q fortune; or functions -e fish_greeting && exit
command -q cowsay; or functions -e fish_greeting && exit

set -q HOMEBREW_PREFIX; or set -l HOMEBREW_PREFIX (realpath (dirname (which brew))/..)

function fish_greeting
  fortune | cowsay -n -W 80 -f (ls $HOMEBREW_PREFIX/share/cows/*.cow | shuf -n1)
end
