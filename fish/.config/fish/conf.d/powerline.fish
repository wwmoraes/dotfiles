# Add powerline function bindings
if test -d "/usr/share/powerline"
  set fish_function_path $fish_function_path "/usr/share/powerline/bindings/fish"
else if test -d "$PYTHON_PATH/site-packages"
  set fish_function_path $fish_function_path "$PYTHON_PATH/site-packages/powerline/bindings/fish"
end

# Setup powerline if installed
if functions -q powerline-setup
  powerline-setup
end
