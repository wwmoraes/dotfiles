function isWork -d 'return true if on a work host'
	set -l hosts "Williams-MacBook-Pro"
  return (contains (hostname -s) $hosts)
end
