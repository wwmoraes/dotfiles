{
  flake.modules.homeManager.william = {
    programs.gpg = {
      publicKeys = [
        {
          source = ./wwmoraes.asc;
          trust = "ultimate";
        }
      ];

      settings =
        let
          key = "32B4330B1B66828E4A969EEBEED994645D7C9BDE"; # gitleaks:allow
        in
        {
          # Default key ID to use (helpful with throw-keyids)
          default-key = key;
          default-keyserver-url = "https://artero.dev/pgp.asc";
          sig-keyserver-url = "https://artero.dev/pgp.asc";
          trusted-key = key;
        };
    };
  };
}
