set -U GO_TASK_PROGNAME task

complete -e task

function __task_get_tasks --description "Prints all available tasks with their description"
	# Read the list of tasks (and potential errors)
	task --list-all 2>&1 | read -lz rawOutput

	# Return on non-zero exit code (for cases when there is no Taskfile found or etc.)
	if test $status -ne 0
		return
	end

	# Grab names and descriptions (if any) of the tasks
	set -l output (echo $rawOutput | sed -e '1d; s/\* \(.*\):\s*\(.*\)\s*(aliases.*/\1\t\2/' -e 's/\* \(.*\):\s*\(.*\)/\1\t\2/'| string split0)
	if test $output
		echo $output
	end
end

complete -c task -d 'Runs the specified task(s). Falls back to the "default" task if no task name was specified, or lists all tasks if an unknown task name was
specified.' -xa "(__task_get_tasks)"

complete -c task -s c -l color     -d 'colored output (default true)'
complete -c task -s d -l dir       -d 'sets directory of execution'
complete -c task      -l dry       -d 'compiles and prints tasks in the order that they would be run, without executing them'
complete -c task -s f -l force     -d 'forces execution even when the task is up-to-date'
complete -c task -s h -l help      -d 'shows Task usage'
complete -c task -s i -l init      -d 'creates a new Taskfile.yml in the current folder'
complete -c task -s l -l list      -d 'lists tasks with description of current Taskfile'
complete -c task -s o -l output    -d 'sets output style: [interleaved|group|prefixed]' -xa "interleaved group prefixed"
complete -c task -s p -l parallel  -d 'executes tasks provided on command line in parallel'
complete -c task -s s -l silent    -d 'disables echoing'
complete -c task      -l status    -d 'exits with non-zero exit code if any of the given tasks is not up-to-date'
complete -c task      -l summary   -d 'show summary about a task'
complete -c task -s t -l taskfile  -d 'choose which Taskfile to run. Defaults to "Taskfile.yml"'
complete -c task -s v -l verbose   -d 'enables verbose mode'
complete -c task      -l version   -d 'show Task version'
complete -c task -s w -l watch     -d 'enables watch of the given task'
