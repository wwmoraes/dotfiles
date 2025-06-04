{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.gpg-agent = {
    pinentry = {
      package = pkgs.pinentry_mac;
      program = "pinentry-mac";
    };
  };

  launchd.agents = {
    gpg-agent.config = {
      ProgramArguments = lib.mkForce [
        "${lib.getExe' config.programs.gpg.package "gpg-agent"}"
        "--daemon" # upstream --supervised not supported in darwin
      ];
      # configure as a one-off launch instead of daemon; mostly useful so the
      # retards from CISO @ work won't complain about an "unknown daemon" 🙄
      KeepAlive = lib.mkForce false;
      Sockets = {
        Agent = {
          SockPassive = false;
          SockPathName = lib.mkForce "${config.programs.gpg.homedir}/S.gpg-agent";
        };
        Extra = {
          SockPassive = false;
          SockPathName = lib.mkForce "${config.programs.gpg.homedir}/S.gpg-agent.extra";
        };
        Ssh = {
          SockPassive = false;
          SockPathName = lib.mkForce "${config.programs.gpg.homedir}/S.gpg-agent.ssh";
        };
      };
    };
    # "dev.artero.hidutil.YubiKey" = {
    #   config = {
    #     Label = "dev.artero.hidutil.YubiKey";
    #     LaunchEvents = {
    #       "com.apple.iokit.matching" = {
    #         "com.apple.device-attach" = {
    #           IOMatchStream = true;
    #           IOMatchLaunchStream = true;
    #           IOProviderClass = "IOUSBDevice";
    #           ## echo "ibase=16; 1050" | bc
    #           # idProduct = 1031; # 0x407
    #           idProduct = "*"; # 0x407
    #           idVendor = 4176; # 0x1050
    #         };
    #       };
    #     };
    #     ProgramArguments = [
    #       ## TODO https://github.com/snosrap/xpc_set_event_stream_handler
    #       # "/usr/local/bin/xpc_set_event_stream_handler"
    #       "${lib.getExe pkgs.gnupg}"
    #       "--card-status"
    #     ];
    #   };
    # };
  };
}
