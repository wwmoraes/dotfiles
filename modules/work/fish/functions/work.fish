switch "$cmd"
    case demote
        sudo dseditgroup -o edit -d (whoami) -t user admin
    case elevate
        sudo dseditgroup -o edit -a (whoami) -t user admin
    case groups
        set -l EMAIL $argv[1]
        test -n "$EMAIL"
        and az ad user get-member-groups --id "$EMAIL" --query [].displayName -o tsv
    case renice
        set -l pids (ps axc | grep -i 'wdavdaemon\|SEHA\|SharePoint\|OneDrive\|nxtsvc\|dlp_agent\|nessus-agent-module\|JamfDaemon\|nessus-service' | awk '{print $1}')
        echo "renicing..."
        echo $pids | xargs sudo renice 20
        echo "changing IO policy..."
        echo $pids | xargs -n1 sudo taskpolicy -b -t 3 -l 3 -p
    case "*"
        echo "work: unknown command '$cmd'"
end
