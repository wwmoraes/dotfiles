function restart -a name -d "Restarts a MacOS bundle application"
  set -l bundleID (mdls -name kMDItemCFBundleIdentifier -raw "$(mdfind "(kMDItemContentTypeTree=com.apple.application) && (kMDItemDisplayName == '*$name*'cdw)" | head -1)")
  set -l bundlePath (mdfind kMDItemCFBundleIdentifier = "$bundleID")

  test -n "$bundlePath"; or return

  killall "$name" 2>/dev/null
  open $bundlePath
end
