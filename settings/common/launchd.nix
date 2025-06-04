{
  # launchd.daemons = {
  #   "dev.artero.limit.maxfiles" = {
  #     serviceConfig = {
  #       Label = "dev.artero.limit.maxfiles";
  #       ProgramArguments = [
  #         "launchctl"
  #         "limit"
  #         "maxfiles"
  #         "1048576"
  #         "1048576"
  #       ];
  #       RunAtLoad = true;
  #     };
  #   };
  #   "dev.artero.limit.maxproc" = {
  #     serviceConfig = {
  #       Label = "dev.artero.limit.maxproc";
  #       ProgramArguments = [
  #         "launchctl"
  #         "limit"
  #         "maxproc"
  #         "65536"
  #         "65536"
  #       ];
  #       RunAtLoad = true;
  #     };
  #   };
  #   "dev.artero.sysctl" = {
  #     serviceConfig = {
  #       Label = "dev.artero.sysctl";
  #       ProgramArguments = [
  #         "/usr/sbin/sysctl"
  #         "kern.maxfiles=1048576"
  #         "kern.maxfilesperproc=65536"
  #       ];
  #       RunAtLoad = true;
  #     };
  #   };
  # };

  launchd.user.agents = {
    # "dev.artero.environment" = {
    #   script = let
    #    home = builtins.getEnv "HOME";
    #    launchctlEnv = key: value:
    #      if value != null
    #      then "launchctl setenv ${key} ${lib.escapeShellArg (builtins.replaceStrings ["$HOME" "\${HOME}"] [home home] value)}"
    #      else "launchctl unsetenv ${key}";
    #   in lib.concatStringsSep "\n" [
    #    (lib.concatStringsSep "\n" (lib.mapAttrsToList launchctlEnv config.launchd.user.envVariables))
    #    ## purges 'Open With' duplicates + reloads environment variables
    #    # "/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user"
    #   ];
    #   serviceConfig = {
    #    Label = "dev.artero.environment";
    #    LimitLoadToSessionType = [
    #      "Aqua"
    #      "StandardIO"
    #       "Background"
    #     ];
    #     RunAtLoad = true;
    #     # StandardErrorPath = (/. + (builtins.getEnv "HOME") + /Library/Logs/dev.artero.environment.err.log);
    #     # StandardOutPath = (/. + (builtins.getEnv "HOME") + /Library/Logs/dev.artero.environment.out.log);
    #   };
    # };
    # https://gist.github.com/paultheman/808be117d447c490a29d6405975d41bd
    # https://hidutil-generator.netlify.app/
    "dev.artero.hidutil.BTRemoteShutter" = {
      serviceConfig = {
        Label = "dev.artero.hidutil.BTRemoteShutter";
        LaunchEvents = {
          "com.apple.iokit.matching" = {
            "com.apple.bluetooth.hostController" = {
              IOMatchLaunchStream = true;
              IOProviderClass = "IOBluetoothHCIController";
              idProduct = 12850; # 0x3232
              idVendor = 1452; # 0x5ac
            };
          };
        };
        # hidutil property --matching '{"VendorID":1452,"ProductID":12850}' --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingDst":30064771152,"HIDKeyboardModifierMappingSrc":30064771112},{"HIDKeyboardModifierMappingDst":30064771151,"HIDKeyboardModifierMappingSrc":51539607785}]}''
        # hidutil property --matching '{"ProductID":12850,"VendorID":1452}' --get "UserKeyMapping"
        ProgramArguments = [
          # "/usr/local/bin/xpc_set_event_stream_handler"
          "/usr/bin/hidutil"
          "property"
          "--matching"
          (builtins.toJSON {
            VendorID = 1452; # 0x5ac
            ProductID = 12850; # 0x3232
          })
          "--set"
          (builtins.toJSON {
            UserKeyMapping = [
              {
                HIDKeyboardModifierMappingSrc = 30064771112; # 0x700000028 return_or_enter
                HIDKeyboardModifierMappingDst = 30064771152; # 0x700000050 left_arrow
              }
              {
                HIDKeyboardModifierMappingSrc = 51539607785; # 0xC000000E9 volume_increment
                HIDKeyboardModifierMappingDst = 30064771151; # 0x70000004F right_arrow
              }
            ];
          })
        ];
        RunAtLoad = true;
      };
    };
  };
}
