function gl -a cmd -d "lab wrapper" -w lab
  type -q lab; or echo "lab is not installed" && return
  type -q awk; or echo "awk is not installed" && return
  type -q sed; or echo "sed is not installed" && return

  switch "$cmd"
  case yolo
    _lab_yolo $argv[2..-1]
  case "" "*"
    lab $argv
  end
end

function _lab_yolo
  if test (count $argv) -ge 1
    set MRNumber $argv[1]
    set MRLink (lab mr show $MRNumber | tail -n1 | awk '{print $2}')"/diffs"
  else
    set MRLink (env GIT_EDITOR=/usr/bin/true lab mr create -d -s)
    set MRNumber (echo $MRLink | sed -E 's|.*/merge_requests/([0-9]+)/diffs|\1|')
  end

  if test (string length $MRLink || echo 0) -eq 0
    echo "failed to get/generate MR link"
    return 1
  end

  echo $MRLink
  lab mr approve $MRNumber
  lab mr merge origin $MRNumber
  lab ci view
end
complete -xc gl -n __fish_use_subcommand -a yolo -d "creates MR, approves and merges"
