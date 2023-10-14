function lg -a path -d "Launch lazygit on current (or given) directory"
  if not command -q lazygit
    echo "please install lazygit to use this function"
    return 1
  end

  test "$path" != ""; or set -l path $PWD

  pgpz unlock > /dev/null &
  lazygit -p "$path"
end

functions -e _lg_pushd _lg_popd
