if test (uname -s) = "Darwin" && test (uname -m) = "arm64"
  eval (/opt/homebrew/bin/brew shellenv)
  alias brew="arch -arm64 /opt/homebrew/bin/brew"
else
  # skip if brew is not found
  command -q brew; and eval (brew shellenv)
end
