# Abbreviations available only in interactive shells
if status --is-interactive
  # git abbreviations
  if test (type -q git)
    abbr -a -g gco git checkout
  end

  # kubectl abbreviations
  if test (type -q kubectl)
    abbr -a -g k kubectl
    abbr -a -g kgp kubectl get pods
  end

  # work abbreviations
  if test (hostname) = "Williams-MacBook-Pro.local"
  end
end
