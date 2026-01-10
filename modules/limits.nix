{
  flake.modules.darwin.default = {
    # launchd.daemons = {
    #   "dev.artero.limit.maxfiles" = {
    #     serviceConfig = {
    #       Label = "dev.artero.limit.maxfiles";
    #       ProgramArguments = [
    #         "launchctl"
    #         "limit"
    #         "maxfiles"
    #         "16384"
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
    #         "4096"
    #         "8192"
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
  };
}
