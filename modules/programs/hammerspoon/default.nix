{
  flake.modules.darwin.gui =
    {
      config,
      ...
    }:
    {
      home-manager.sharedModules = [
        (
          {
            lib,
            pkgs,
            ...
          }:
          let
            timeout = lib.getExe' pkgs.coreutils "timeout";
            hs = "${pkgs.nur.repos.natsukium.hammerspoon}/Applications/Hammerspoon.app/Contents/Frameworks/hs/hs";
          in
          {
            home.packages = [
              pkgs.nur.repos.natsukium.hammerspoon
            ];

            home.activation.hammerspoonIntegration = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
              test -L /usr/local/bin/hs && unlink /usr/local/bin/hs || true
              test -L /usr/local/share/man/man1/hs.1 && unlink /usr/local/share/man/man1/hs.1 || true

              echo "installing CLI..."
              if ! run ${timeout} --signal INT --kill-after 1s 3s ${hs} -q -c 'hs.ipc.cliInstall()' > /dev/null; then
                echo 'did you load the IPC module? It is required for the CLI to work. You can do so by adding `require("hs.ipc")` to your configuration'
              fi
            '';

            home.file.".hammerspoon" = {
              recursive = true;
              source = ./scripts;
              onChange = ''
                echo "reloading config..."
                if ! run ${timeout} --signal INT --kill-after 1s 3s ${hs} -q -c 'hs.reload()' > /dev/null; then
                  echo 'did you load the IPC module? It is required for the CLI to work. You can do so by adding `require("hs.ipc")` to your configuration'
                fi
              '';
            };
          }
        )
      ];

      system.defaults.CustomSystemPreferences."/Library/Preferences/com.apple.TimeMachine".SkipPaths =
        config.users.users
        |> builtins.attrValues
        |> builtins.concatMap (user: [
          "${user.home}/.hammerspoon"
        ]);
    };
}
