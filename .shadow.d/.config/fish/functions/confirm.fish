function confirm -a prompt -d "Ask the user for confirmation"
  if test -z "$prompt"
    set prompt "Continue?"
  end

  while true
    read -p 'set_color green; echo -n "$prompt [y/N]: "; set_color normal' -l confirm

    switch $confirm
      case Y y
        return 0
      case '' N n
        return 1
    end
  end
end
