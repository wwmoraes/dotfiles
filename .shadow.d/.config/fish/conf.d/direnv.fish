command -q direnv; or exit

## why developers still suggest globals on fish? :P
set -eg direnv_fish_mode

## trigger direnv at prompt, and on every arrow-based directory change (default)
set -U direnv_fish_mode eval_on_arrow

## trigger direnv at prompt, and only after arrow-based directory changes before executing command
# set -U direnv_fish_mode eval_after_arrow

## trigger direnv at prompt only, this is similar functionality to the original behavior
# set -U direnv_fish_mode disable_arrow

direnv hook fish | source
