{
  lib,
  ...
}:
let
  inherit (lib) mkOption types;
in
{
  options = with types; {
    securityModel = mkOption {
      type = enum [
        "passthrough"
        "mapped-xattr"
        "mapped-file"
        "none"
      ];
      default = "none";
      description = ''
        Filesystem attribute security model.

        Mapped ones are useful for persistent chown but are incompatible with symlinks.
      '';
    };
    protocolVersion = mkOption {
      type = enum [
        "9p2000"
        "9p2000.u"
        "9p2000.L"
      ];
      default = "9p2000.L";
      description = ''
        Select 9P protocol version.
      '';
    };
    msize = mkOption {
      type = nullOr str;
      default = null;
      defaultText = lib.literalMD ''
        Lima built-in default: "128KiB"
      '';
      description = ''
        The number of bytes to use for 9p packet payload, where 4KiB is the
        absolute minimum.
      '';
    };
    cache = mkOption {
      type = nullOr (enum [
        "fscache"
        "loose"
        "mmap"
        "none"
      ]);
      default = null;
      defaultText = lib.literalMD ''
        Lima built-in default: "fscache" for read-only mounts, "mmap" otherwise
      '';
      description = ''
        Specifies a caching policy. Try choosing "mmap" or "none" if you see a
        stability issue with the default "fscache".

        See https://www.kernel.org/doc/Documentation/filesystems/9p.txt
      '';
    };
  };
}
