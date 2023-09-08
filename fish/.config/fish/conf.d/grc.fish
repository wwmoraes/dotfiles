# only apply on interactive shells
status --is-interactive; or exit

# don't setup anything if grc is not installed
command -q grc; or exit

# create the grc wrapper functions for the enabled binaries
for executable in (cat ~/.grc/bins.txt | grep -v ":false")
  command -q $executable; or continue

  function $executable --inherit-variable executable --wraps=$executable
    if isatty 1
      grc $executable $argv
    else
      eval command $executable $argv
    end
  end
end

# remove the wrapper function for explicitly disabled binaries
for executable in (cat ~/.grc/bins.txt | grep ":false" | cut -d: -f1)
  functions -e $executable
end
