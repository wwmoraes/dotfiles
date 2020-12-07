function isPersonal -d 'return true if on a personal host'
	set -l hosts "arch-linux" "M1Cabuk"
  return (contains (hostname -s) $hosts)
end
