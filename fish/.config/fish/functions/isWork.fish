function isWork -d 'return true if on a work host'
	set -l hosts "NLMBF04E-C82334"
  return (contains (hostname -s) $hosts)
end
