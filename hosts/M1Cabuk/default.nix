{
  config,
  ...
}:
{
  environment.etc = {
    "u2f_mappings" = {
      enable = true;
      # nix run nixpkgs#pam_u2f -- --pin-verification --nouser
      text = builtins.concatStringsSep ":" [
        config.system.primaryUser
        "smTC1lZ3/QBwJuP2zmGVs5YdUVA7qoqxxHQQIgLOSij6AA76ZzFU4V1cqiDuDsmCv9anji+AqXhr6OSVIvJ6Iw==,5WYu7NefCvu8FfUVefBd1JJkbfA4ksLZJd8Y8n+9QZ1CObbL1l+Z2Q9awT4YXK5Ihfg59PpQZYqQG2KngM4wFA==,es256,+presence+pin" # DevSrvsID:4294970243, serial number 15411734
        "/vTguIXJTDpvM1GYTFn/FU/3QumOPZaMot0Wu86bWtz47fVNmcrhkGSif/C2YARdaGRN1AijmtUsJ7++LMHGeA==,Ex/1Lapj/trzTkwm8viwrKuGkicHIvvByvHgoUaHbPn687/Uai3HxPjFBseUkuh7vol9sOMYXmWhB7fZ9V3Icg==,es256,+presence+pin" # DevSrvsID:4298640537, serial number 16395429
        "3jnyl4V4XHHKQ6nHP067ejJqJ6G5c7ZFVCmfvvPAUzlo/2ThIrBXzlt7GLsUxKqrC/aKd9tZEg/jEwn3K+WTxg==,Vcj/nZFD98+ftNIp/I2qwg7qApouBeusEq7AKAkTaxsshVkbF0fGgfpskzGt8LTL8T26WyuYOC5WZhSILrAsng==,es256,+presence+pin" # DevSrvsID:4298640674, serial number 13137398
        "VRDqAFrIO69Iklta4fJpVg9UYW3K/EcBC4o1ZMqHxqAbJvINDf4+jh1PRGq7Bla2+Xp7YISpWdIvft7+rjz5sA==,tRgySpumrM/DVqaVEUDKykx/pIew9fhjVhZ4d+yVHhL4g10djeSIewAe6EsI0HRq+0ltf7JDBYtdneNYPxOt2g==,es256,+presence+pin" # DevSrvsID:4298640748, serial number 16816210
        "FlPVd7c8WgRreiOoOfc+BCpTNLW1MrDQsBsmY37xGxXvkLtDPYgJI3VA+UZ6HwwztZdljNp23pxy3iK9OcXr+Q==,DEsTLDzW1cMAQiDSNUFOsuVd87Q16gu/wIcPg2y0xpXElBkD1IWk2CNKpyyQpKTmHSBFF58oLziTc1JlHwClvw==,es256,+presence+pin" # DevSrvsID:4298640787, serial number 16816208
      ];
    };
  };
  networking = {
    computerName = " M1 Cabuk";
    domain = "home.arpa";
    hostName = "M1Cabuk";
    localHostName = "M1Cabuk";
  };
}
