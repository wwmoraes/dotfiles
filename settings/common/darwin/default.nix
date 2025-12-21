{
  imports = [
    # keep-sorted start
    ./home
    ./programs
    ./security
    ./services
    # keep-sorted end

    # keep-sorted start
    ./environment.nix
    ./home-manager.nix
    ./homebrew.nix
    ./launchd.nix
    ./nix-homebrew.nix
    ./nix.nix
    ./sops.nix
    ./system.nix
    ./users.nix
    # keep-sorted end
  ];
}
