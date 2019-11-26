function isLinux -d 'return true if on a Linux'
	return (test (uname -s) = "Linux")
end
