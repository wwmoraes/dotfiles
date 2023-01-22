function fix-app-icon -a app -a icon
  set -l PlistBuddy /usr/libexec/PlistBuddy
  command -q $PlistBuddy; or begin
    echo "$PlistBuddy not found"
    return 2
  end

  test -n "$app" -a -n "$icon"; or begin
    printf "usage: %s <app-path> <icon-path>\n" (status function)
    return 1
  end

  test -d "$app"; or begin
    echo "application not found"
    return 1
  end

  set -l infoPlist (realpath "$app/Contents/Info.plist" 2> /dev/null)
  test -n "$infoPlist" -a -f "$infoPlist"; or begin
    echo "application path is not a valid MacOS bundle"
    return 1
  end

  set -l currentIconFile ($PlistBuddy -c 'print CFBundleIconFile' $infoPlist 2> /dev/null)
  test -z "$currentIconFile"; or begin
    echo "Application already has an icon set"
    return 1
  end

  test -f "$icon"; or begin
    echo "icon not found"
    return 1
  end

  set -l iconType (file -b --mime-type $icon)
  test (file -b --mime-type $icon) = "image/x-icns"; or begin
    echo "icon must be an ICNS"
    return 1
  end

  cp $icon (realpath "$app/Contents/Resources")"/Icon.icns"
  $PlistBuddy -c "Add CFBundleIconFile string Icon.icns" $infoPlist
  touch $app

  echo "done!"
end
