function flg -d "Fuzzy launches lazygit on all git-enabled subfolders"
  if not type -q lazygit
    echo "please install lazygit to use this function"
    return 1
  end

  set -l path (fls)
  test (string length $path || echo 0) -ne 0; or return

  pushd "$path" > /dev/null
  lazygit
  popd > /dev/null
end
