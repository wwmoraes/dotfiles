function reload-config -d "force-reloads all fish config"
  source ~/.config/fish/config.fish

  for confFilePath in ~/.config/fish/conf.d/*.fish
    source $confFilePath
  end

  for completionsFilePath in ~/.config/fish/completions/*.fish
    source $completionsFilePath
  end

  for functionFilePath in ~/.config/fish/functions/*.fish
    source $functionFilePath
  end
end
