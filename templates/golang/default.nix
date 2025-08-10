{
  pkgs,
  ...
}:

pkgs.buildGoApplication rec {
  pname = "hello";
  version = "0.0.0";

  src =
    with pkgs.lib.fileset;
    toSource {
      root = ./.;
      fileset = unions [
        (fileFilter (file: file.hasExt "go") ./.)
        (maybeMissing ./go.sum)
        ./go.mod
      ];
    };

  modules = ./gomod2nix.toml;
  subPackages = [ "cmd/hello" ];

  CGO_ENABLED = 0;
  GOFLAGS = "-trimpath";

  ldflags = [
    "-s"
    "-w"
    "-buildid="
    "-X main.version=${version}"
  ];

  meta = {
    description = "a fancy new golang project";
    homepage = "https://github.com/wwmoraes/hello";
    license = pkgs.lib.licenses.mit;
    maintainers = [ pkgs.lib.maintainers.wwmoraes or "wwmoraes" ];
    mainProgram = "hello";
  };
}
