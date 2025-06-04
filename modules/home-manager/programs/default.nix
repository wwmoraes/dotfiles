{
  imports = [
    ./docker.nix
    ./git-ps.nix
    ./powerline-go.nix
  ];

  disabledModules = [
    "programs/powerline-go.nix"
  ];
}
