function fls -d "Fuzzy lists git-enabled folders"
  type -q fzf; or echo "please install fzf to use this function" && return 1

  # get paths from env or use defaults
  set -q GIT_PROJECT_PATHS; or set -l GIT_PROJECT_PATHS .

  # remove duplicate paths
  set -l PROJECT_PATHS
  for path in $GIT_PROJECT_PATHS
    set -l path (realpath $path)
    contains $path $PROJECT_PATHS; or set -a PROJECT_PATHS "$path"
  end

  # tmp folder & fifo setup
  set -l tmpDir (mktemp -d)
  set -l fifoFD $tmpDir/flg
  mkfifo $fifoFD
  trap 'rm -rf $tmpDir' EXIT

  # runs find in bg
  find \
    $PROJECT_PATHS \
    -maxdepth 2 \
    -name .git \
    -type d \
    -exec sh -c '\
      printf "%-80s %s\n" \
        "`echo $(git -C "{}" remote get-url origin 2> /dev/null || echo "<none>") | sed -E "s#^https://[^/]+/(.*)\.git#\1#;s/^[^:]+:(.*)\.git/\1/"`" "`dirname "{}" | xargs -I% realpath "%"`"' \; |\
    awk 'BEGIN{printf "%-80s%s%s%s","ORIGIN",FS,"PATH",RS};{print $0;system("")}' > $fifoFD 2> /dev/null &

  # save pid and disown
  set PID (jobs -lp | tail +1)
  disown $PID
  trap 'kill $PID' EXIT

  # fuzzy find and launch lazygit
  set -l selection (fzf --header-lines=1 < $fifoFD); or return $status
  set -l path (echo $selection | awk '{print $2}')

  test (string length $path || echo 0) -ne 0; and echo $path
end
