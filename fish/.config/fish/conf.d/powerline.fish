# Add powerline function bindings
set -l PYTHON_USER_BASE (python3 -m site --user-base)
if test -d "$PYTHON_USER_BASE/bin"
  set fish_function_path $fish_function_path "$PYTHON_USER_BASE/lib/python/site-packages/powerline/bindings/fish"
  source "$PYTHON_USER_BASE/lib/python/site-packages/powerline/bindings/fish/powerline-setup.fish"
else if test -d "$PYTHON_PATH/site-packages"
  set fish_function_path $fish_function_path "$PYTHON_PATH/site-packages/powerline/bindings/fish"
  source "$PYTHON_PATH/site-packages/powerline/bindings/fish/powerline-setup.fish"
else if test -d "/usr/share/powerline"
  set fish_function_path $fish_function_path "/usr/share/powerline/bindings/fish"
  source "/usr/share/powerline/bindings/fish/powerline-setup.fish"
end

# Setup powerline if installed
functions -q powerline-setup; and powerline-setup > /dev/null ^&1
