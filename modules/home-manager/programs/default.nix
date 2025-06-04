{
  imports = [
    # keep-sorted start
    ./helix
    # keep-sorted end

    # keep-sorted start
    ./docker.nix
    ./git-ps.nix
    ./powerline-go.nix
    # keep-sorted end
  ];

  disabledModules = [
    "programs/powerline-go.nix"
  ];
}
