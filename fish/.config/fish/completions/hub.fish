complete -c hub --wraps git

function __fish_hub_needs_command
  set cmd (commandline -opc)
  if [ (count $cmd) -eq 1 ]
    return 0
  else
    return 1
  end
end

function  __fish_hub_using_command
  set cmd (commandline -opc)
  set subcmd_count (count $argv)
  if [ (count $cmd) -gt "$subcmd_count" ]
    for i in (seq 1 "$subcmd_count")
      if [ "$argv[$i]" != $cmd[(math "$i" + 1)] ]
        return 1
      end
    end
    return 0
  else
    return 1
  end
end

function __fish_hub_prs
    command hub pr list -f %I\t%t%n 2>/dev/null
end

complete -f -c hub -n '__fish_hub_needs_command' -a alias -d "show shell instructions for wrapping git"
complete -f -c hub -n '__fish_hub_needs_command' -a browse -d "browse the project on GitHub"
complete -f -c hub -n '__fish_hub_needs_command' -a compare -d "lookup commit in GitHub Status API"
complete -f -c hub -n '__fish_hub_needs_command' -a create -d "create new repo on GitHub for the current project"
complete -f -c hub -n '__fish_hub_needs_command' -a delete -d "delete a GitHub repo"
complete -f -c hub -n '__fish_hub_needs_command' -a fork -d "fork origin repo on GitHub"
complete -f -c hub -n '__fish_hub_needs_command' -a pull-request -d "open a pull request on GitHub"
complete -f -c hub -n '__fish_hub_needs_command' -a pr -d "list or checkout GitHub pull requests"
complete -f -c hub -n '__fish_hub_needs_command' -a issue -d "list or create a GitHub issue"
complete -f -c hub -n '__fish_hub_needs_command' -a release -d "list or create a GitHub release"
complete -f -c hub -n '__fish_hub_needs_command' -a ci-status -d "display GitHub Status information for a commit"
complete -f -c hub -n '__fish_hub_needs_command' -a sync -d "update local branches from upstream"

# alias
complete -f -c hub -n ' __fish_hub_using_command alias' -a 'bash zsh sh ksh csh fish' -d "output shell script suitable for eval"
# pull-request
complete -f -c hub -n ' __fish_hub_using_command pull-request' -s f -d "Skip the check for unpushed commits"
complete -f -c hub -n ' __fish_hub_using_command pull-request' -s -m -d "Set the pull request title and description separated by a blank line"
complete -f -c hub -n ' __fish_hub_using_command pull-request' -s F -d "Read the pull request title and description from <FILE>"
complete -f -c hub -n ' __fish_hub_using_command pull-request' -s o -d "Open the new pull request in a web browser"
complete -f -c hub -n ' __fish_hub_using_command pull-request' -l browse -d "Open the new pull request in a web browser"
complete -f -c hub -n ' __fish_hub_using_command pull-request' -s p -d "Push the current branch to <HEAD> before creating the pull request"
complete -f -c hub -n ' __fish_hub_using_command pull-request' -s b -d 'The base branch in "[OWNER:]BRANCH" format'
complete -f -c hub -n ' __fish_hub_using_command pull-request' -s h -d 'The head branch in "[OWNER:]BRANCH" format'
complete -f -c hub -n ' __fish_hub_using_command pull-request' -s a -d 'A comma-separated list of GitHub handles to assign to this pull request'
complete -f -c hub -n ' __fish_hub_using_command pull-request' -s M -d "The milestone name to add to this pull request. Passing the milestone number is deprecated."
complete -f -c hub -n ' __fish_hub_using_command pull-request' -s l -d "Add a comma-separated list of labels to this pull request"
# pr
set -l pr_commands list checkout show
complete -f -c hub -n ' __fish_hub_using_command pr' -l color -xa 'always never auto' -d 'enable colored output even if stdout is not a terminal. WHEN can be one of "always" (default for --color), "never", or "auto" (default).'
## pr list
complete -f -c hub -n " __fish_hub_using_command pr; and not __fish_seen_subcommand_from $pr_commands" -a list -d "list pull requests in the current repository"
complete -f -c hub -n ' __fish_hub_using_command pr list' -s s -l state -xa 'open closed merged all' -d 'filter pull requests by STATE. default: open'
complete -f -c hub -n ' __fish_hub_using_command pr list' -s h -l head -d 'show pull requests started from the specified head BRANCH in "[OWNER:]BRANCH" format'
complete -f -c hub -n ' __fish_hub_using_command pr list' -s b -l base -d 'show pull requests based off the specified BRANCH'
complete -f -c hub -n ' __fish_hub_using_command pr list' -s o -l sort -xa 'created updated popularity long-running' -d 'default: created'
complete -f -c hub -n ' __fish_hub_using_command pr list' -s '^' -l sort-ascending -d 'sort by ascending dates instead of descending'
complete -f -c hub -n ' __fish_hub_using_command pr list' -s f -l format -d 'pretty print the list of pull requests using format FORMAT (default: "%pC%>(8)%i%Creset  %t%  l%n")'
complete -f -c hub -n ' __fish_hub_using_command pr list' -s L -l limit -d 'display only the first LIMIT issues'
## pr checkout
complete -f -c hub -n " __fish_hub_using_command pr; and not __fish_seen_subcommand_from $pr_commands" -a checkout -d "check out the head of a pull request in a new branch"
complete -f -r -c hub -n ' __fish_hub_using_command pr checkout' -a '(__fish_hub_prs)'
## pr show
complete -f -c hub -n " __fish_hub_using_command pr; and not __fish_seen_subcommand_from $pr_commands" -a show -d "open a pull request page in a web browser"
complete -f -c hub -n ' __fish_hub_using_command pr show' -a '(__fish_hub_prs)'
complete -f -c hub -n ' __fish_hub_using_command pr show' -s u -d "print the pull request URL instead of opening it"
complete -f -c hub -n ' __fish_hub_using_command pr show' -s c -d "put the pull request URL to clipboard instead of opening it"
# fork
complete -f -c hub -n ' __fish_hub_using_command fork' -l no-remote -d "Skip adding a git remote for the fork"
# browse
complete -f -c hub -n ' __fish_hub_using_command browse' -s u -d "Print the URL instead of opening it"
complete -f -c hub -n ' __fish_hub_using_command browse' -s c -d "Put the URL in clipboard instead of opening it"
complete -f -c hub -n ' __fish_hub_using_command browse' -a '-- commits' -d 'commits'
complete -f -c hub -n ' __fish_hub_using_command browse' -a '-- contributors' -d 'contributors'
complete -f -c hub -n ' __fish_hub_using_command browse' -a '-- issues' -d 'issues'
complete -f -c hub -n ' __fish_hub_using_command browse' -a '-- pulls' -d 'pull requests'
complete -f -c hub -n ' __fish_hub_using_command browse' -a '-- wiki' -d 'wiki'
# compare
complete -f -c hub -n ' __fish_hub_using_command compare' -s u -d 'Print the URL instead of opening it'
# create
complete -f -c hub -n ' __fish_hub_using_command create' -s o -d "Open the new repository in a web browser"
complete -f -c hub -n ' __fish_hub_using_command create' -l browse -d "Open the new repository in a web browser"
complete -f -c hub -n ' __fish_hub_using_command create' -s p -d "Create a private repository"
complete -f -c hub -n ' __fish_hub_using_command create' -s c -d "Put the URL of the new repository to clipboard instead of printing it."
complete -f -c hub -n ' __fish_hub_using_command create' -l copy -d "Put the URL of the new repository to clipboard instead of printing it."
# delete
complete -f -c hub -n ' __fish_hub_using_command delete' -s y -d "Skip the confirmation prompt"
complete -f -c hub -n ' __fish_hub_using_command delete' -l yes -d "Skip the confirmation prompt"
# ci-status
complete -f -c hub -n ' __fish_hub_using_command ci-status' -s v -d "Print detailed report of all status checks and their URLs"
