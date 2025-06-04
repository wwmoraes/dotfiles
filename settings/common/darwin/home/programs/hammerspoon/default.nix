{
  lib,
  pkgs,
  ...
}:
{
  home.packages = [
    pkgs.nur.repos.natsukium.hammerspoon
  ];

  home.activation.hammerspoonIntegration = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    test -L /usr/local/bin/hs && unlink /usr/local/bin/hs || true
    test -L /usr/local/share/man/man1/hs.1 && unlink /usr/local/share/man/man1/hs.1 || true
    ${pkgs.nur.repos.natsukium.hammerspoon}/Applications/Hammerspoon.app/Contents/Frameworks/hs/hs -q -c 'hs.ipc.cliInstall()' > /dev/null || true
  '';

  home.file.".hammerspoon" = {
    recursive = true;
    source = ./scripts;
    onChange = ''
      ${pkgs.nur.repos.natsukium.hammerspoon}/Applications/Hammerspoon.app/Contents/Frameworks/hs/hs -q -c 'hs.reload()' > /dev/null || true
    '';
  };
}
