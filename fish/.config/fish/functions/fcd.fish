function fcd -d "Fuzzy change directory to a git-enabled project one"
  set -l path (fls)
  test (string length $path || echo 0) -ne 0; or return

  cd "$path"
end
