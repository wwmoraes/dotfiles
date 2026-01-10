{
  flake.modules.homeManager.development =
    {
      config,
      lib,
      ...
    }:
    {
      home.activation.developerGroupMembership = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        if ! _=$(groups ${config.home.username} | xargs -n1 | grep -Fx _developer > /dev/null); then
          echo >&2 "adding user ${config.home.username} to group _developer"
          run sudo dscl . append /Groups/_developer GroupMembership "${config.home.username}"
        fi
      '';
      home.activation.webdeveloperGroupMembership = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        if ! _=$(groups ${config.home.username} | xargs -n1 | grep -Fx _webdeveloper > /dev/null); then
          echo >&2 "adding user ${config.home.username} to group _webdeveloper"
          run sudo dscl . append /Groups/_webdeveloper GroupMembership "${config.home.username}"
        fi
      '';

      ## skipping this for now as the write replaces the group in the policy instead of adding
      # echo "allowing _developer members to change system preferences"
      # # shellcheck disable=SC2024
      # sudo security authorizationdb read system.preferences > /tmp/system.preferences.plist
      # sudo defaults write /tmp/system.preferences.plist group _developer
      # # shellcheck disable=SC2024
      # sudo security authorizationdb write system.preferences < /tmp/system.preferences.plist
    };

  flake.modules.darwin.development = {
    system.activationScripts.postActivation.text = ''
      if ! /usr/sbin/DevToolsSecurity -status | grep -Fx "Developer mode is currently enabled." > /dev/null; then
        printf >&2 "enabling developer mode...\n"
        /usr/sbin/DevToolsSecurity -enable
      fi

      printf >&2 "allowing any app source...\n"
      spctl --master-enable

      printf >&2 "reloading system settings...\n"
      /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u

      printf >&2 "reloading preferences...\n"
      killall cfprefsd
    '';
  };
}
