# Add powerline function bindings
set fish_function_path $fish_function_path "$HOME/.local/lib/python2.7/site-packages/powerline/bindings/fish"

# Setup powerline if installed
if functions -q powerline-setup
    powerline-setup
end
