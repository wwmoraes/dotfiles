#!/usr/bin/env fish

function bundleid
  test (count $argv) -gt 0; or begin
    set -a argv (lsappinfo list |\
      stdbuf -o L grep -E '\\s*[0-9]+\\) .* ASN:0x0-0x.*' |\
      cut -d'"' -f2 | fzf)

    test (count $argv) -gt 0; or return 2
  end

  lsappinfo info -only bundleid $argv[1] | cut -d= -f2 | xargs
end
