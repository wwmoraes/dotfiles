function fco -d "Checkout local git branch, sorted by recent"
  git branch -vv | read -z branches; 
  git checkout (echo "$branch" | awk '{print $1}' | sed "s/.* //")
  set branch (echo "$branches" | fzf-tmux +m)
