test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish;
and source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish

# early exit in nix-daemon.fish leaves function defined
functions -e add_path

test -e /nix/var/nix/profiles/default/etc/profile.d/nix.fish;
and source /nix/var/nix/profiles/default/etc/profile.d/nix.fish

source /etc/fish/nixos-env-preinit.fish

## filtered logic out of https://github.com/kidonng/nix.fish


function __fish_nix_uninstall --on-event nix_uninstall
  set --erase NIX_{GIT_SSL_CAINFO,PATH,PROFILES,SSL_CERT_FILE}
end

# set --local profile ~/.nix-profile
# test -n "$MANPATH" && ! contains $profile/share/man $MANPATH
# and set --prepend MANPATH $profile/share/man

function __fish_nix_install --on-event nix_install
  set --local packages (string match --regex "/nix/store/[\w.-]+" $PATH)
  fish_add_path --global --append $packages/bin

  if test (count $packages) != 0
    set fish_complete_path $fish_complete_path[1] \
      $packages/etc/fish/completions \
      $packages/share/fish/vendor_completions.d \
      $fish_complete_path[2..]
    set fish_function_path $fish_function_path[1] \
      $packages/etc/fish/functions \
      $packages/share/fish/vendor_functions.d \
      $fish_function_path[2..]

    for file in $packages/etc/fish/conf.d/*.fish $packages/share/fish/vendor_conf.d/*.fish
      if ! test -f (string replace --regex "^.*/" $__fish_config_dir/conf.d/ -- $file)
        source $file
      end
    end
  end
end
