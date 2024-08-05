test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish;
and source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish

# early exit in nix-daemon.fish leaves function defined
functions -e add_path

test -e /nix/var/nix/profiles/default/etc/profile.d/nix.fish;
and source /nix/var/nix/profiles/default/etc/profile.d/nix.fish

source /etc/fish/setEnvironment.fish
