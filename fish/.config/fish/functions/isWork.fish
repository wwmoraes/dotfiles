function isWork -d 'return true if on a work host'
	set -l hosts "C02DQ36NMD6P"
  return (contains (hostname -s) $hosts)
end
