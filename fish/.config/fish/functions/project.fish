function project
  git status --porcelain 2>/dev/null >&2; or begin
    echo "not a git project" > /dev/stderr
    return 1
  end

  set name (git remote get-url (git remote | head -1) 2> /dev/null)
  # remove .git suffix
  set name (string replace -r "\.git\$" "" $name)
  # remove git prefix for SSH URLs
  set name (string replace -r "^git@.*:" "" $name)
  # remove HTTP prefix
  set name (string replace -r "^https?://(?:[^@]+@)?[^/]+/" "" $name)
  # remove Azure DevOps /_git/ from the middle of the URL
  set name (string replace -r "/_git/" "/" $name)
  # remove keybase prefix
  set name (string replace -r "^keybase://[^/]+/" "" $name)

  echo $name
end
