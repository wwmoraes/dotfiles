rec {
  default = meta;

  golang = {
    path = ./golang;
    description = "Golang project";
    welcomeText = ''
      # Golang project

      Replace `hello` with the name of this project in these files:

      - .golangci.yaml
      - .goreleaser.yml
      - default.nix
      - flake.nix
      - go.mod

      Check also descriptions fields in some of these files. Happy hacking!

      NOTE: fresh repositories need git initialized for flakes and direnv to
      work. That means `git init . && git add -N . && direnv allow` should get
      you up-and-running in record time ;)
    '';
  };

  meta = {
    path = ./meta;
    description = "Common documentation and settings for all projects";
    welcomeText = ''
      # Meta files

      Replace `hello` with the name of your project, such as in:

      - README.md
      - SECURITY.md
    '';
  };
}
