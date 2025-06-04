{
  pkgs,
  ...
}:
{
  home.packages = [
    pkgs.exiftool
  ];

  programs.git = {
    attributes = [
      "*.ico diff=exif"
      "*.jpeg diff=exif"
      "*.jpg diff=exif"
      "*.png diff=exif"
    ];
    extraConfig.diff.exif = {
      textConv = "exiftool -sort -x Directory";
      cachetextconv = true;
      binary = true;
    };
  };
}
