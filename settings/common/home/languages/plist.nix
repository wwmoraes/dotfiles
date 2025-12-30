{
  pkgs,
  ...
}:
{
  home.packages = [
    pkgs.libplist
  ];

  programs.git = {
    attributes = [
      "*.plist diff=plist"
    ];
    settings.diff.plist = {
      textConv = "plistutil --sort --format xml --infile";
      cachetextconv = true;
      binary = true;
    };
  };
}
