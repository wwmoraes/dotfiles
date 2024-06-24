# don't setup anything if nix is not installed
command -q nix; or exit

test -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish'; or exit

source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish'
