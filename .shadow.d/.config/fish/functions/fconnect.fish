function fconnect -d "fuzzy connect to a host"
	command -q fzf; or echo "fzf is not installed" && return
	command -q ssh; or echo "ssh is not installed" && return

	set -l host (find -L ~/.ssh -type f \
		-exec awk '/^Host (.*\*.*|github.com)/ {next};/^Host/ {print $2}' '{}' \; | \
		sort | \
		uniq | \
		fzf --print-query --header="HOST" --prompt="Which host you want to connect to? " | tail -n1); or return

		test -n "$host"; or return 2

		set options "mosh/tmux" "ssh/tmux" mosh ssh

		set -l connType (printf "%s\n" $options | fzf --header="TYPE" --prompt="What type of connection to use? ")

		test -n "$connType"; or return 2

		set extraArgs ""

		string match -qr -- "ssh/?.*" $connType
		and set tool ssh -tt

		string match -qr -- "mosh/?.*" $connType
		and begin
			command -q mosh; or echo "mosh is not installed" && return
			set tool mosh --ssh="ssh -tt" --no-ssh-pty
		end

		string match -q -- "*/tmux" $connType; and begin
			# echo -n "tmux session name: "
			read -P "tmux session name [default: main] > " session
			test -z "$session"; and set session main
			set extraArgs tmux -u new -A -s $session
		end

		echo connecting to $host...
		$tool $host -- $extraArgs
end
