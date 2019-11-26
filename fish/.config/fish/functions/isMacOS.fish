function isMacOS -d "return true if on a MacOS"
  return (test (uname -s) = "Darwin")
end
