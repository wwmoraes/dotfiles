function work -a cmd -d "work utilities so I can stay productive"
  switch "$cmd"
    case start
      set -l daemons (launchctl list | awk '$1 != "-" {print}')
      for f in /Library/LaunchAgents/*
        set -l label (/usr/libexec/PlistBuddy -c 'Print Label' $f)
        echo $daemons | grep -qF $label; and continue

        echo "loading $label"
        launchctl load -w $f 2> /dev/null
      end
      for f in /Library/LaunchDaemons/*
        set -l label (/usr/libexec/PlistBuddy -c 'Print Label' $f)
        echo $daemons | grep -qF $label; and continue

        echo "loading $label"
        launchctl load -w $f 2> /dev/null
      end

      set -l applications \
        'Bartender 5' \
        'Das Keyboard Q' \
        'DisplayLink Manager' \
        'Elgato Stream Deck' \
        'Gas Mask' \
        'Keeper Password Manager' \
        Amethyst \
        amm \
        Finicky \
        Flux \
        Hammerspoon \
        SwiftBar

      set -l processes (ps aux)
      for app in $applications
        echo $processes | grep -qF "$app.app"; and continue

        echo "opening $app"
        open -a "$app"
      end
    case elevate
      sudo dseditgroup -o edit -a (whoami) -t user admin
    case demote
      sudo dseditgroup -o edit -d (whoami) -t user admin
    case groups
      az ad user get-member-groups --id $EMAIL --query [].displayName -o tsv
    case "*"
      echo "work: unknown command '$cmd'"
  end
end

complete -xc work -n __fish_use_subcommand -a elevate -d "adds the current user account to the admin group"
complete -xc work -n __fish_use_subcommand -a demote -d "removes the current user account from the admin group"
