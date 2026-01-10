set -l sha256 (nix-hash --flat --base64 --type sha256 (nix-prefetch-url --print-path $argv | tail -n +2))
echo "sha256-$sha256"
