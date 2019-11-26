function isPersonal -d 'return true if on a personal host'
	set -l hosts "arch-linux"
  return (contains (hostname) $hosts)
end
