{
  home-manager = {
    sharedModules = [
      (
        { config, lib, ... }:
        {
          home.activation.developerGroupMembership = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            if ! _=$(groups ${config.home.username} | xargs -n1 | grep -Fx _developer > /dev/null); then
              echo >&2 "adding user ${config.home.username} to group _developer"
              sudo dscl . append /Groups/_developer GroupMembership "${config.home.username}"
            fi
          '';
          home.activation.webdeveloperGroupMembership = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            if ! _=$(groups ${config.home.username} | xargs -n1 | grep -Fx _webdeveloper > /dev/null); then
              echo >&2 "adding user ${config.home.username} to group _webdeveloper"
              sudo dscl . append /Groups/_webdeveloper GroupMembership "${config.home.username}"
            fi
          '';
          ## skipping this for now as the write replaces the group in the policy instead of adding
          # echo "allowing _developer members to change system preferences"
          # # shellcheck disable=SC2024
          # sudo security authorizationdb read system.preferences > /tmp/system.preferences.plist
          # sudo defaults write /tmp/system.preferences.plist group _developer
          # # shellcheck disable=SC2024
          # sudo security authorizationdb write system.preferences < /tmp/system.preferences.plist
        }
      )
    ];
  };
}
