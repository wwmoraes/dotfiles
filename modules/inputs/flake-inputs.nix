{
  flake-file.inputs.flake-utils = {
    inputs.systems.follows = "systems";
    url = "github:numtide/flake-utils";
  };
}
