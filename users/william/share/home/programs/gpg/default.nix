{
  programs.gpg = {
    publicKeys = [
      {
        source = ./wwmoraes.asc;
        trust = "ultimate";
      }
    ];

    settings = rec {
      default-key = "32B4330B1B66828E4A969EEBEED994645D7C9BDE"; # gitleaks:allow
      default-keyserver-url = "https://artero.dev/pgp.asc";
      sig-keyserver-url = "https://artero.dev/pgp.asc";
      trusted-key = default-key;
    };
  };
}
