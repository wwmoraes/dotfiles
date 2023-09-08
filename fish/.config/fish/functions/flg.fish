function flg -d "Fuzzy launches lazygit on all git-enabled subfolders"
  command -q lazygit; or echo "please install lazygit to use this function" && return 1

  set -l path (fls $argv)
  test (string length $path || echo 0) -ne 0; or return

  pushd "$path" > /dev/null
  lazygit
  popd > /dev/null
end
