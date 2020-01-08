function flg -d "Fuzzy launches lazygit on all git-enabled subfolders"
  if not type -q lazygit
    echo "please install lazygit to use this function"
    return 1
  end

  # tmp folder & fifo setup
  set -l tmpDir (mktemp -d)
  set -l fifoFD $tmpDir/flg
  mkfifo $fifoFD
  trap 'rm -rf $tmpDir' EXIT

  # runs find in bg
  find \
    . \
    ~/dev/ \
    ~/workspace/ \
    -name .git \
    -type d \
    -exec sh -c '\
      printf "%-80s %s\n" \
        `echo $(git -C {} remote get-url origin 2> /dev/null || echo "<none>") | sed -E "s#^https://[^/]+/(.*)\.git#\1#;s/^[^:]+:(.*)\.git/\1/" | xargs` \
        `dirname {} | xargs realpath`' \; |\
    awk 'BEGIN{OFS="\t";printf "%-80s %s\n","ORIGIN","PATH"};{print $0;system("")}' > $fifoFD 2> /dev/null &

  # save pid and disown
  set PID (jobs -lp | tail +1)
  disown $PID
  trap 'kill $PID' EXIT

  # fuzzy find and launch lazygit
  set -l selection (fzf --header-lines=1 < $fifoFD); or return $status
  set -l path (echo $selection | awk '{print $2}')

  test (string length $path || echo 0) -ne 0; and emit flg_open $path
end

function _flg_open -a path --on-event flg_open
  pushd "$path" > /dev/null
  lazygit
  popd > /dev/null
end
