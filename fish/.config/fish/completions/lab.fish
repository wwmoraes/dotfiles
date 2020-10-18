complete -c lab --wraps hub

# function __fish_hub_prs
#     command hub pr list -f %I\t%t%n 2>/dev/null
# end

complete -f -c lab -n '__fish_needs_command' -a ci -d "Work with GitLab CI pipelines and jobs"

# alias
complete -f -c lab -n ' __fish_using_command ci' -l create -d "Create a CI pipeline"
complete -f -c lab -n ' __fish_using_command ci' -l lint -d "Validate .gitlab-ci.yml against GitLab"
complete -f -c lab -n ' __fish_using_command ci' -l status -d "Textual representation of a CI pipeline"
complete -f -c lab -n ' __fish_using_command ci' -l trace -d "Trace the output of a ci job"
complete -f -c lab -n ' __fish_using_command ci' -l trigger -d "Trigger a CI pipeline"
complete -f -c lab -n ' __fish_using_command ci' -l view -d "View, run, trace, and/or cancel CI jobs current pipeline"
