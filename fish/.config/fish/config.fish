# Remove the global version, as it shadows the universal one
set -eg fish_user_paths

# Funny greeting messages
set -U fish_greeting (curl -fs --max-time 0.3 http://whatthecommit.com/index.txt; or echo "")
