function fish_user_key_bindings
  # Ctrl-A: save previous command as a snippet
  bind \ca 'pet new $history[1]; commandline -f repaint'
  # Ctrl-S: select a snippet
  bind \cs 'commandline (pet search --color --query (commandline)); commandline -f repaint'
  # Ctrl-R: reload config
  bind \cr 'reload-config'
end
