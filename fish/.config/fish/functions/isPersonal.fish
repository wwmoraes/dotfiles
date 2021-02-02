function isPersonal -d 'return true if on a personal host'
	set -l hosts "M1Cabuk"
  return (contains (hostname -s) $hosts)
end
