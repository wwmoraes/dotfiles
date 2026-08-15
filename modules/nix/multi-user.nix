{
  flake.modules.darwin.multi-user = { config, lib, ... }: {
    ids.gids.nixbld = 350;
    # XXX: on multi-user the daemon runs as root, which initiates all SSH
    # connections. The alternatives would be either to use plain key files
    # for the builders, or setup root's own GPG identity and agent. Both seem
    # less worth than forwarding to the "real" admin socket.
    launchd.daemons.nix-daemon.environment.SSH_AUTH_SOCK =
      lib.mkDefault config.home-manager.users.william.launchd.agents.gpg-agent.config.Sockets.Ssh.SockPathName;
    nix.enable = true;
  };
}
