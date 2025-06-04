{
  programs.gpg = {
    publicKeys = [
      {
        source = ./wwmoraes.asc;
        trust = "ultimate";
      }
    ];

    settings = {
      default-key = "32B4330B1B66828E4A969EEBEED994645D7C9BDE";
      default-keyserver-url = "https://artero.dev/pgp.asc";
      sig-keyserver-url = "https://artero.dev/pgp.asc";
      trusted-key = "32B4330B1B66828E4A969EEBEED994645D7C9BDE";
    };
  };
}
