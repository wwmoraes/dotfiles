function lg -a path -d "Launch lazygit on current (or given) directory"
  if test "$path" != ""; emit lg_open $path; end
  lazygit
  if test "$path" != ""; emit lg_close; end
end

function _lg_pushd -a path --on-event lg_open
  pushd "$path" > /dev/null
end

function _lg_popd --on-event lg_close
  popd > /dev/null
end