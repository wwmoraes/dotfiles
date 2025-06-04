{
  nix.extraOptions = ''
    connect-timeout = 15
    http2 = false
    max-jobs = 1
    stalled-download-timeout = 600
  '';
}
