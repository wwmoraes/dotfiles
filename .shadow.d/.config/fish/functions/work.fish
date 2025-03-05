function work -a cmd -d "work utilities so I can stay productive"
  switch "$cmd"
    case start
      set -l daemons (launchctl list | awk '$1 != "-" {print}')
      for f in /Library/LaunchAgents/{com.jamf.,com.zscaler.}*.plist
        set -l label (/usr/libexec/PlistBuddy -c 'Print Label' $f)
        echo $daemons | grep -qF $label; and continue

        echo "loading $label"
        launchctl load -w $f 2> /dev/null
      end
      for f in /Library/LaunchDaemons/{com.jamf.,com.zscaler.,com.snowsoftware.}*.plist
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
    case stop
      for f in /Library/Launch{Agents,Daemons}/*.plist
        set -l label (/usr/libexec/PlistBuddy -c 'Print Label' $f)
        echo "stopping $label"
        sudo launchctl bootout "system/$label"
      end
    case elevate
      sudo dseditgroup -o edit -a (whoami) -t user admin
    case demote
      sudo dseditgroup -o edit -d (whoami) -t user admin
    case groups
      az ad user get-member-groups --id $EMAIL --query [].displayName -o tsv
    case update
      for f in /Library/LaunchDaemons/{com.jamf.,com.zscaler.}*.plist
        set -l label (/usr/libexec/PlistBuddy -c 'Print Label' $f)
        echo $daemons | grep -qF $label; and continue

        echo "loading $label"
        launchctl load -w $f 2> /dev/null
      end
      sudo softwareupdate --install --all --force --restart --agree-to-license
    case "*"
      echo "work: unknown command '$cmd'"
  end
end

complete -xc work -n __fish_use_subcommand -a elevate \
  -d "adds the current user account to the admin group"
complete -xc work -n __fish_use_subcommand -a demote \
  -d "removes the current user account from the admin group"
complete -xc work -n __fish_use_subcommand -a start \
  -d "bootstraps launch daemons, agents and login items in safe boot mode"
complete -xc work -n __fish_use_subcommand -a update \
  -d "applies the OS software updates"
complete -xc work -n __fish_use_subcommand -a groups \
  -d "lists AD groups for the principal in EMAIL"
