function fish_greeting
  command -q fortune; or return
  command -q cowsay; or return

  fortune | cowsay -n -W 80 --random
end
