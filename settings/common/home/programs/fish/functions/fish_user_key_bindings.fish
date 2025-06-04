# Execute this once per mode that emacs bindings should be used in
fish_default_key_bindings -M insert

# Then execute the vi-bindings so they take precedence when there's a conflict.
# Without --no-erase fish_vi_key_bindings will default to
# resetting all bindings.
# The argument specifies the initial mode (insert, "default" or visual).
fish_vi_key_bindings --no-erase insert

bind ctrl-a 'echo $history[1] | nap shell/(date +"%s").fish' repaint
bind -M insert ctrl-a 'echo $history[1] | nap shell/(date +"%s").fish' repaint

bind ctrl-down 'commandline --replace -- (nap list | fzf | ifne xargs nap)' repaint
bind -M insert ctrl-down 'commandline --replace -- (nap list | fzf | ifne xargs nap)' repaint

# bind ctrl-a 'pet new $history[1]' repaint
# bind -M insert ctrl-a 'pet new $history[1]' repaint

# bind ctrl-down 'commandline --replace -- (pet search --query (commandline))' repaint
# bind -M insert ctrl-down 'commandline --replace -- (pet search --query (commandline))' repaint
