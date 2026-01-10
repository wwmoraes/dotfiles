## recovers the original command status before hooks execution
set -q __fish_last_status; and set -l status $__fish_last_status
