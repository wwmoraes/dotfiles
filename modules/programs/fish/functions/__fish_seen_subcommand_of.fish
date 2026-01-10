set -l cmd (commandline -opc)
set -e cmd[1]
set -l tokens (string replace -r --filter '^([^-].*)' '$1' -- $cmd)

argparse --name=prefix p/prefix -- $argv
or return

set -l argc (count $argv)
set -l tokens_count (count $tokens)

# check if prefix mode is enabled
if string length -q -- $_flag_prefix
    # no match if the requirements are greater than the available tokens
    test $argc -gt $tokens_count
    and return 1
else
    # must have the exact count
    test $argc -eq $tokens_count
    or return 1
end

# check if there's tokens to compare to
test $tokens_count -gt 0
# no tokens, so we return false if there's any requirements
or return (test $argc -le 0)

for i in (seq 1 $argc)
    if not string match -q "{$argv[$i]}" "{$tokens[$i]}"
        return 1
    end
end

return 0
