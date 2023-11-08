command -q fortune; or exit
command -q cowsay; or exit

function fish_greeting
  fortune | cowsay -n -W 80 -f (ls /opt/homebrew/share/cows/*.cow | shuf -n1)
end
