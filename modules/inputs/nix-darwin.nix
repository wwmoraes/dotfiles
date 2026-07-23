{
  flake-file.inputs.nix-darwin = {
    inputs.nixpkgs.follows = "nixpkgs";
    url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
  };
}
