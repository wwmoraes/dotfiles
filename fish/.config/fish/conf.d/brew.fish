if test (uname -m) = "arm64"
  eval (/opt/homebrew/bin/brew shellenv)
  alias brew="arch -arm64 /opt/homebrew/bin/brew"
else
  eval (/usr/local/Homebrew/bin/brew shellenv)
end
