command -q fortune; or functions -e fish_greeting && exit
command -q cowsay; or functions -e fish_greeting && exit

function fish_greeting
  fortune | cowsay -n -W 80 -f (ls /opt/homebrew/share/cows/*.cow | shuf -n1)
end
