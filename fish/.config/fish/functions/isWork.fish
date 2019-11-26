function isWork -d 'return true if on a work host'
	set -l hosts "Williams-MacBook-Pro.local"
  return (contains (hostname) $hosts)
end
