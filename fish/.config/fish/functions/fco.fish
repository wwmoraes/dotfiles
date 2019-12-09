function fco -d "Checkout local git branch, sorted by recent"
  git branch -vv | read -z branches;
  set branch (echo "$branches" | fzf-tmux +m)
  test (string length $branch || echo 0) -ne 0; and git checkout (echo "$branch" | awk '{print $1}' | sed "s/.* //")
end
