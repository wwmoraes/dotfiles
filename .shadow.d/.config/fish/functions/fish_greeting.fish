command -q fortune; or exit
command -q cowsay; or exit

function fish_greeting
  fortune | cowsay -n -W 80 --random
end
