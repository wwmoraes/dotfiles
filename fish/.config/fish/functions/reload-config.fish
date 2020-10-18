function reload-config
  source ~/.config/fish/config.fish
  for conf in ~/.config/fish/conf.d/*.fish
    source $conf
  end
end
