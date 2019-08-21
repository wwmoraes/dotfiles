# home binaries
set PATH $HOME/.local/bin $PATH 

# Fisher bootstrap
if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

# Powerline
set fish_function_path $fish_function_path "$HOME/.local/lib/python2.7/site-packages/powerline/bindings/fish"
powerline-setup
