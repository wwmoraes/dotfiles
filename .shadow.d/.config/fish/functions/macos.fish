set -a APP_PATH /Applications:$HOME/Applications
function macos -a cmd -d "MacOS utilities"
  set -e argv[1]
  if not isatty
    while read -l arg
      set -a argv $arg
    end
  end

  switch "$cmd"
    case hide-on-dock
      _macos_hide-on-dock $argv
    case show-on-dock
      _macos_show-on-dock $argv
    case "" "*"
      echo "unknown subcommand $cmd"
  end
end
complete -ec macos

function __macos_get_apppath
  if test (count $argv) -eq 1
    set appPath $argv[1]
  else
    set appPath (mdfind "kMDItemContentType == 'com.apple.application-bundle'" | \
      grep -vE "^/(Library|System)" | \
      fzf)
  end

  test "(string sub -l 1 $appPath)" = "/"; or begin
    for PREFIX in $APP_PATH
      test -d "$PREFIX/$appPath"; or continue
      set appPath "$PREFIX/$appPath"
      break
    end
  end

  echo $appPath
end

function _macos_hide-on-dock
  set appPath (__macos_get_apppath $argv[1])

  test -f "$appPath/Contents/Info.plist"; or begin
    echo "path does not contain an application bundle property list"
    return 1
  end

  sudo /usr/libexec/PlistBuddy -c 'Set :LSUIElement true' "$appPath/Contents/Info.plist" 2>/dev/null
  or sudo /usr/libexec/PlistBuddy -c 'Add :LSUIElement bool true' "$appPath/Contents/Info.plist" 2>/dev/null

  echo "done - please reopen the app"
end
complete -xc macos -n __fish_use_subcommand -a hide-on-dock -d "makes the app hide its icon on Dock"

function _macos_show-on-dock
  set appPath (__macos_get_apppath $argv[1])

  test -f "$appPath/Contents/Info.plist"; or begin
    echo "path does not contain an application bundle property list"
    return 1
  end

  sudo /usr/libexec/PlistBuddy -c 'Delete :LSUIElement' "$appPath/Contents/Info.plist" 2>/dev/null
  echo "done - please reopen the app"
end
complete -xc macos -n __fish_use_subcommand -a show-on-dock -d "makes the app hide its icon on Dock"
