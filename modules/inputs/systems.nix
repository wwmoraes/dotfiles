{
  inputs,
  ...
}:
{
  flake-file.inputs.systems.url = "github:nix-systems/default";

  systems = builtins.filter (system: system != "x86_64-darwin") (import inputs.systems);
}
