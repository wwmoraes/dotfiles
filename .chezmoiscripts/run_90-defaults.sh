#!/usr/bin/env sh

set -eum
trap 'kill 0' INT HUP TERM

test "${TRACE:-0}" = "1" && set -x
test "${VERBOSE:-0}" = "1" && set -v

# run only on darwin
test "${CHEZMOI_OS:-}" = "darwin" || exit

# skip changing defaults
test "${DEFAULTS:-0}" = "0" && exit

printf "\e[1;33mDarwin defaults\e[0m\n"
## sane defaults on https://github.com/kevinSuttle/macOS-Defaults

## close system preferences to avoid it overriding any settings done here
# cspell:disable-next-line
osascript -e 'tell application "System Preferences" to quit'

## Ask for the administrator password upfront
sudo -v

## Keep-alive: update existing `sudo` time stamp until the parent has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
### UI/UX
###############################################################################
#region UI/UX

printf "\e[1;34mUI/UX\e[0m\n"

echo "setting: disable the sound effects on boot"
# cspell:disable-next-line
sudo nvram SystemAudioVolume=" "

# echo "setting: disable transparency in the menu bar and elsewhere on Yosemite"
# cspell:disable-next-line
# sudo defaults write com.apple.universalaccess reduceTransparency -bool true

echo "setting: set sidebar icon size to medium"
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2

echo "setting: only show scrollbar when scrolling"
defaults write NSGlobalDomain AppleShowScrollBars -string "WhenScrolling"

echo "setting: disable the over-the-top focus ring animation"
defaults write NSGlobalDomain NSUseAnimatedFocusRing -bool false

echo "setting: enable smooth scrolling"
defaults write NSGlobalDomain NSScrollAnimationEnabled -bool true

echo "setting: increase window resize speed for Cocoa applications"
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

echo "setting: expand save panel by default"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

echo "setting: expand print panel by default"
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

echo "setting: save to disk (not to iCloud) by default"
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

echo "setting: automatically quit printer app once the print jobs complete"
# cspell:disable-next-line
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

echo "setting: disable the 'Are you sure you want to open this application?' dialog"
defaults write com.apple.LaunchServices LSQuarantine -bool false

# cspell:disable
echo "setting: remove duplicates in the 'Open With' menu (also see 'lscleanup' alias)"
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user
# cspell:enable

echo "setting: display ASCII control characters using caret notation in standard text views"
# cspell:disable-next-line
## try e.g. `cd /tmp; unidecode "\x{0000}" > cc.txt; open -e cc.txt`
defaults write NSGlobalDomain NSTextShowsControlCharacters -bool true

# echo "setting: Disable Resume system-wide"
# cspell:disable-next-line
# defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

# echo "setting: Disable automatic termination of inactive apps"
# defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

# echo "setting: Disable the crash reporter"
# defaults write com.apple.CrashReporter DialogType -string "none"

echo "setting: Set Help Viewer windows to non-floating mode"
# cspell:disable-next-line
defaults write com.apple.helpviewer DevMode -bool true

## Commented out, as this is known to cause problems in various Adobe apps :(
## See https://github.com/mathiasbynens/dotfiles/issues/237
# echo "setting: Fix for the ancient UTF-8 bug in QuickLook (https://mths.be/bbo)"
# echo "0x08000100:0" > ~/.CFUserTextEncoding

echo "setting: Reveal host info when clicking the clock in the login window"
# cspell:disable-next-line
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

# echo "setting: Disable Notification Center and remove the menu bar icon"
# cspell:disable-next-line
# launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist 2> /dev/null

echo "setting: use a lighter text rendering style"
defaults write AppleFontSmoothing -int 1

echo "setting: disable the animations for opening Quick Look windows"
defaults write QLPanelAnimationDuration -float 0

# echo "setting: don't blink the caret (the value is in milliseconds)"
# defaults write NSTextInsertionPointBlinkPeriod -int 9999999999999999

#endregion

################################################################################
### Peripherals
################################################################################
#region peripherals

printf "\e[1;34mPeripherals\e[0m\n"

echo "setting: Disable automatic capitalization as it's annoying when typing code"
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

echo "setting: Disable smart dashes as they're annoying when typing code"
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

echo "setting: Disable automatic period substitution as it's annoying when typing code"
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

echo "setting: Disable smart quotes as they're annoying when typing code"
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

echo "setting: Disable auto-correct"
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

echo "setting: disable checking spelling while typing"
defaults write NSGlobalDomain NSAllowContinuousSpellChecking -bool false

echo "setting: Increase sound quality for Bluetooth headphones/headsets"
# cspell:disable-next-line
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

echo "setting: Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs)"
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

echo "setting: Disable press-and-hold for keys in favor of key repeat"
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

echo "setting: Set fast keyboard repeat rate"
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

## Note: if you're in the US, replace `EUR` with `USD`, `Centimeters` with
## `Inches`, `en_GB` with `en_US`, and `true` with `false`.
echo "setting: Set language and text formats"
defaults write NSGlobalDomain AppleLanguages -array "en-NL" "en-GB" "pt-BR"
defaults write NSGlobalDomain AppleLocale -string "en_GB@currency=EUR"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
defaults write NSGlobalDomain AppleMetricUnits -bool true

# echo "setting: Stop iTunes from responding to the keyboard media keys"
# launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2> /dev/null

#endregion

################################################################################
### Energy saving
################################################################################
#region energy saving

printf "\e[1;34mEnergy saving\e[0m\n"

echo "setting: Enable lid wake-up"
# cspell:disable-next-line
sudo pmset -a lidwake 1

echo "setting: Restart automatically on power loss"
# cspell:disable-next-line
sudo pmset -a autorestart 1

echo "setting: Restart automatically if the computer freezes"
# cspell:disable-next-line
sudo systemsetup -setrestartfreeze on

echo "setting: Sleep the display after 15 minutes"
# cspell:disable-next-line
sudo pmset -a displaysleep 2

echo "setting: Disable machine sleep while charging"
# cspell:disable-next-line
sudo pmset -c sleep 0

echo "setting: Set machine sleep to 5 minutes on battery"
# cspell:disable-next-line
sudo pmset -b sleep 5

echo "setting: Set standby delay to 24 hours (default is 1 hour)"
# cspell:disable-next-line
sudo pmset -a standbydelay 86400

echo "setting: Never go into computer sleep mode"
# cspell:disable-next-line
sudo systemsetup -setcomputersleep Off > /dev/null

## 0: Disable hibernation (speeds up entering sleep mode)
## 3: Copy RAM to disk so the system state can still be restored in case of a
##    power failure.
echo "setting: Hibernation mode"
# cspell:disable-next-line
sudo pmset -a hibernatemode 0

## Remove the sleep image file to save disk space
# cspell:disable-next-line
# test -f /private/var/vm/sleepimage && sudo rm /private/var/vm/sleepimage

## Create a zero-byte file instead…
# cspell:disable-next-line
# sudo touch /private/var/vm/sleepimage

## …and make sure it can't be rewritten
# cspell:disable-next-line
# sudo chflags uchg /private/var/vm/sleepimage

#endregion

################################################################################
### Screen
################################################################################
#region screen

printf "\e[1;34mScreen\e[0m\n"

echo "setting: Require password immediately after sleep or screen saver begins"
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

echo "setting: Save screenshots to the desktop"
# cspell:disable-next-line
defaults write com.apple.screencapture location -string "${HOME}/Desktop"

echo "setting: Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)"
# cspell:disable-next-line
defaults write com.apple.screencapture type -string "png"

echo "setting: Disable shadow in screenshots"
# cspell:disable-next-line
defaults write com.apple.screencapture disable-shadow -bool true

## Reference: https://github.com/kevinSuttle/macOS-Defaults/issues/17#issuecomment-266633501
echo "setting: Enable subpixel font rendering on non-Apple LCDs"
defaults write NSGlobalDomain AppleFontSmoothing -int 1

echo "setting: Enable HiDPI display modes (requires restart)"
# cspell:disable-next-line
sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true

#endregion

################################################################################
### Finder
################################################################################
#region finder

printf "\e[1;34mFinder\e[0m\n"

echo "setting: set home folder as the default location on new window/tabs"
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

echo "setting: show icons for hard drives, servers, and removable media on the desktop"
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# echo "setting: show hidden files by default"
# defaults write com.apple.finder AppleShowAllFiles -bool true

echo "setting: hide all file extensions"
defaults write NSGlobalDomain AppleShowAllExtensions -bool false

echo "setting: show status bar"
defaults write com.apple.finder ShowStatusBar -bool true

echo "setting: show path bar"
# cspell:disable-next-line
defaults write com.apple.finder ShowPathbar -bool true

echo "setting: Display full POSIX path as Finder window title"
defaults write com.apple.finder _FXShowPosixPathInTitle -bool false

echo "setting: Keep folders on top when sorting by name"
defaults write com.apple.finder _FXSortFoldersFirst -bool true

echo "setting: When performing a search, search the current folder by default"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

echo "setting: Disable the warning when changing a file extension"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

echo "setting: Enable spring loading for directories"
defaults write NSGlobalDomain com.apple.springing.enabled -bool true

echo "setting: Remove the spring loading delay for directories"
defaults write NSGlobalDomain com.apple.springing.delay -float 0

echo "setting: Avoid creating .DS_Store files on network or USB volumes"
# cspell:disable
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
# cspell:enable

echo "setting: Disable disk image verification"
# cspell:disable
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true
# cspell:enable

echo "setting: Automatically open a new Finder window when a volume is mounted"
# cspell:disable
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true
# cspell:enable

echo "setting: Show item info near icons on the desktop and in other icon views"
# cspell:disable
# /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:showItemInfo true" "${HOME}/Library/Preferences/com.apple.finder.plist"
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo true" "${HOME}/Library/Preferences/com.apple.finder.plist"
# cspell:enable

# echo "setting: Show item info to the right of the icons on the desktop"
# cspell:disable-next-line
# /usr/libexec/PlistBuddy -c "Set DesktopViewSettings:IconViewSettings:labelOnBottom false" ~/Library/Preferences/com.apple.finder.plist

echo "setting:Enable snap-to-grid for icons on the desktop and in other icon views"
# cspell:disable
# /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" "${HOME}/Library/Preferences/com.apple.finder.plist"
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" "${HOME}/Library/Preferences/com.apple.finder.plist"
# cspell:enable

echo "setting:Increase grid spacing for icons on the desktop and in other icon views"
# cspell:disable
# /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 100" "${HOME}/Library/Preferences/com.apple.finder.plist"
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 100" "${HOME}/Library/Preferences/com.apple.finder.plist"
# cspell:enable

echo "setting:Increase the size of icons on the desktop and in other icon views"
# cspell:disable
# /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 80" "${HOME}/Library/Preferences/com.apple.finder.plist"
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 80" "${HOME}/Library/Preferences/com.apple.finder.plist"
# cspell:enable

# cspell:disable-next-line
## Four-letter codes for the other view modes: `icnv`, `clmv`, `glyv`
echo "setting: Use list view in all Finder windows by default"
# cspell:disable-next-line
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

echo "setting: Disable the warning before emptying the Trash"
defaults write com.apple.finder WarnOnEmptyTrash -bool false

echo "setting: Enable AirDrop over Ethernet and on unsupported Macs running Lion"
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

echo "setting: always show the user Library folder"
# cspell:disable-next-line
chflags nohidden "${HOME}/Library"

echo "setting: Show the /Volumes folder"
# cspell:disable-next-line
sudo chflags nohidden /Volumes

echo "setting: Expand 'General', 'Open with' and 'Sharing & Permissions' on File Info panes"
defaults write com.apple.finder FXInfoPanesExpanded -dict \
  General -bool true \
  OpenWith -bool true \
  Privileges -bool true

echo "setting: enable text selection on QuickLook"
defaults write com.apple.finder QLEnableTextSelection -bool true

#endregion

################################################################################
### Dock, Dashboard, and hot corners
################################################################################
#region dock

printf "\e[1;34mDock, Menu & Desktop\e[0m\n"

echo "setting: Enable highlight hover effect for the grid view of a stack (Dock)"
# cspell:disable-next-line
defaults write com.apple.dock mouse-over-hilite-stack -bool true

echo "setting: Set the icon size of Dock items to 36 pixels"
# cspell:disable-next-line
defaults write com.apple.dock tilesize -int 72

echo "setting: Change minimize/maximize window effect"
# cspell:disable-next-line
defaults write com.apple.dock mineffect -string "genie"

echo "setting: Minimize windows into their application's icon"
defaults write com.apple.dock minimize-to-application -bool true

echo "setting: Enable spring loading for all Dock items"
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true

echo "setting: Show indicator lights for open applications in the Dock"
defaults write com.apple.dock show-process-indicators -bool true

echo "setting: show translucent icons for hidden apps"
# cspell:disable-next-line
defaults write com.apple.Dock showhidden -bool yes

echo "setting: Speed up Mission Control animations"
defaults write com.apple.dock expose-animation-duration -float 0.1

echo "setting: Disable Dashboard"
defaults write com.apple.dashboard mcx-disabled -bool true

echo "setting: Don't show Dashboard as a Space"
defaults write com.apple.dock dashboard-in-overlay -bool true

echo "setting: Don't automatically rearrange Spaces based on most recent use"
defaults write com.apple.dock mru-spaces -bool false

echo "setting: Remove the auto-hiding Dock delay"
# cspell:disable-next-line
defaults write com.apple.dock autohide-delay -float 0

echo "setting: Automatically hide and show the Dock"
# cspell:disable-next-line
defaults write com.apple.dock autohide -bool true

echo "setting: Don't show recent applications in Dock"
# cspell:disable-next-line
defaults write com.apple.dock show-recents -bool false

#endregion

################################################################################
### Safari & WebKit
################################################################################
#region safari

printf "\e[1;34mSafari & WebKit\e[0m\n"

echo "setting: Privacy: don't send search queries to Apple"
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true

echo "setting: Press Tab to highlight each item on a web page"
defaults write com.apple.Safari WebKitTabToLinksPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks -bool true

echo "setting: Show the full URL in the address bar (note: this still hides the scheme)"
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

echo "setting: Set Safari's home page to $(about:blank) for faster loading"
defaults write com.apple.Safari HomePage -string "about:blank"

echo "setting: Prevent Safari from opening 'safe' files automatically after downloading"
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

echo "setting: Allow hitting the Backspace key to go to the previous page in history"
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled -bool false

echo "setting: Show Safari's bookmarks bar by default"
defaults write com.apple.Safari ShowFavoritesBar -bool true

echo "setting: Show Safari's sidebar in Top Sites"
defaults write com.apple.Safari ShowSidebarInTopSites -bool true

echo "setting: Disable Safari's thumbnail cache for History and Top Sites"
defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2

echo "setting: Enable Safari's debug menu"
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

echo "setting: Make Safari's search banners default to Contains instead of Starts With"
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

echo "setting: Remove useless icons from Safari's bookmarks bar"
defaults write com.apple.Safari ProxiesInBookmarksBar "()"

echo "setting: Enable the Develop menu and the Web Inspector in Safari"
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

echo "setting: Add a context menu item for showing the Web Inspector in web views"
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

echo "setting: Enable continuous spellchecking"
defaults write com.apple.Safari WebContinuousSpellCheckingEnabled -bool true

echo "setting: Disable auto-correct"
defaults write com.apple.Safari WebAutomaticSpellingCorrectionEnabled -bool false

echo "setting: Disable AutoFill"
defaults write com.apple.Safari AutoFillFromAddressBook -bool false
defaults write com.apple.Safari AutoFillPasswords -bool false
defaults write com.apple.Safari AutoFillCreditCardData -bool false
defaults write com.apple.Safari AutoFillMiscellaneousForms -bool false

echo "setting: Warn about fraudulent websites"
defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true

echo "setting: Enable plug-ins"
defaults write com.apple.Safari WebKitPluginsEnabled -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2PluginsEnabled -bool true

echo "setting: Disable Java"
defaults write com.apple.Safari WebKitJavaEnabled -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabled -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabledForLocalFiles -bool false

echo "setting: Block pop-up windows"
defaults write com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically -bool false

echo "setting: Disable auto-playing video"
defaults write com.apple.Safari WebKitMediaPlaybackAllowsInline -bool false
defaults write com.apple.SafariTechnologyPreview WebKitMediaPlaybackAllowsInline -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2AllowsInlineMediaPlayback -bool false
defaults write com.apple.SafariTechnologyPreview com.apple.Safari.ContentPageGroupIdentifier.WebKit2AllowsInlineMediaPlayback -bool false

echo "setting: Disable 'Do Not Track'"
defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool false

echo "setting: Update extensions automatically"
defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true

#endregion

################################################################################
### Mail
################################################################################
#region mail

printf "\e[1;34mMail\e[0m\n"

echo "setting: Disable send and reply animations in Mail.app"
defaults write com.apple.mail DisableReplyAnimations -bool true
defaults write com.apple.mail DisableSendAnimations -bool true

echo "setting: Copy email addresses as 'foo@example.com' instead of 'Foo Bar <foo@example.com>' in Mail.app"
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

echo "setting: Add the keyboard shortcut ⌘ + Enter to send an email in Mail.app"
defaults write com.apple.mail NSUserKeyEquivalents -dict-add "Send" "@\U21a9"

echo "setting: Display emails in threaded mode, sorted by date (newest at the top)"
defaults write com.apple.mail DraftsViewerAttributes -dict-add "DisplayInThreadedMode" -string "yes"
defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortedDescending" -string "no"
defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortOrder" -string "received-date"

echo "setting: Disable inline attachments (just show the icons)"
defaults write com.apple.mail DisableInlineAttachmentViewing -bool true

echo "setting: Disable automatic spell checking"
defaults write com.apple.mail SpellCheckingBehavior -string "NoSpellCheckingEnabled"

#endregion

################################################################################
### Spotlight
################################################################################
#region spotlight

printf "\e[1;34mSpotlight\e[0m\n"

# echo "setting: Disable Spotlight indexing for any volume that gets mounted and not indexed before"
# sudo defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes"

echo "setting: Change indexing order and disable some search results"
# cspell:disable
defaults write com.apple.spotlight orderedItems -array \
  '{"enabled" = 1;"name" = "APPLICATIONS";}' \
  '{"enabled" = 1;"name" = "SYSTEM_PREFS";}' \
  '{"enabled" = 1;"name" = "DIRECTORIES";}' \
  '{"enabled" = 1;"name" = "PDF";}' \
  '{"enabled" = 1;"name" = "FONTS";}' \
  '{"enabled" = 0;"name" = "DOCUMENTS";}' \
  '{"enabled" = 0;"name" = "MESSAGES";}' \
  '{"enabled" = 0;"name" = "CONTACT";}' \
  '{"enabled" = 0;"name" = "EVENT_TODO";}' \
  '{"enabled" = 0;"name" = "IMAGES";}' \
  '{"enabled" = 0;"name" = "BOOKMARKS";}' \
  '{"enabled" = 0;"name" = "MUSIC";}' \
  '{"enabled" = 0;"name" = "MOVIES";}' \
  '{"enabled" = 0;"name" = "PRESENTATIONS";}' \
  '{"enabled" = 0;"name" = "SPREADSHEETS";}' \
  '{"enabled" = 0;"name" = "SOURCE";}' \
  '{"enabled" = 0;"name" = "MENU_DEFINITION";}' \
  '{"enabled" = 0;"name" = "MENU_OTHER";}' \
  '{"enabled" = 1;"name" = "MENU_CONVERSION";}' \
  '{"enabled" = 1;"name" = "MENU_EXPRESSION";}' \
  '{"enabled" = 0;"name" = "MENU_WEBSEARCH";}' \
  '{"enabled" = 0;"name" = "MENU_SPOTLIGHT_SUGGESTIONS";}'
# cspell:enable

echo "action: Load new settings before rebuilding the index"
# cspell:disable-next-line
killall mds > /dev/null || true

echo "action: enable indexing for the main volume"
# cspell:disable-next-line
sudo mdutil -i on / > /dev/null

# echo "action: Rebuild the index from scratch"
# cspell:disable-next-line
# sudo mdutil -E / > /dev/null

#endregion

################################################################################
### Terminal
################################################################################
#region terminal

printf "\e[1;34mTerminal\e[0m\n"

echo "setting: Only use UTF-8 in Terminal.app"
defaults write com.apple.terminal StringEncodings -array 4

## See: https://security.stackexchange.com/a/47786/8918
echo "setting: Enable Secure Keyboard Entry in Terminal.app"
defaults write com.apple.terminal SecureKeyboardEntry -bool true

echo "setting: Disable the annoying line marks"
defaults write com.apple.Terminal ShowLineMarks -int 0

#endregion

################################################################################
### TimeMachine
################################################################################
#region time machine

printf "\e[1;34mTime Machine\e[0m\n"

echo "setting: Prevent Time Machine from prompting to use new hard drives as backup volume"
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# echo "setting: Disable local Time Machine backups"
# cspell:disable-next-line
# hash tmutil > /dev/null 2>&1 && sudo tmutil disablelocal

echo "setting: thin local Time Machine snapshots"
# cspell:disable-next-line
hash tmutil > /dev/null 2>&1 && sudo tmutil thinlocalsnapshots / 1000000000 1 > /dev/null 2>&1

#endregion

################################################################################
### Activity Monitor
################################################################################
#region activity monitor

printf "\e[1;34mActivity Monitor\e[0m\n"

echo "setting: Show the main window when launching Activity Monitor"
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

echo "setting: Visualize CPU usage in the Activity Monitor Dock icon"
defaults write com.apple.ActivityMonitor IconType -int 5

echo "setting: Show all processes in Activity Monitor"
defaults write com.apple.ActivityMonitor ShowCategory -int 0

echo "setting: Sort Activity Monitor results by CPU usage"
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

#endregion

###############################################################################
# Address Book, Dashboard, iCal, TextEdit, and Disk Utility                   #
###############################################################################
#region utilities

printf "\e[1;34mUtilities\e[0m\n"

echo "setting: Enable the debug menu in Address Book"
# cspell:disable-next-line
defaults write com.apple.addressbook ABShowDebugMenu -bool true

echo "setting: Disable Dashboard dev mode (allows keeping widgets on the desktop)"
# cspell:disable-next-line
defaults write com.apple.dashboard devmode -bool false

echo "setting: Enable the debug menu in iCal (pre-10.8)"
defaults write com.apple.iCal IncludeDebugMenu -bool true

echo "setting: Use plain text mode for new TextEdit documents"
defaults write com.apple.TextEdit RichText -int 0

echo "setting: Open and save files as UTF-8 in TextEdit"
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

echo "setting: Enable the debug menu in Disk Utility"
defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true
defaults write com.apple.DiskUtility advanced-image-options -bool true

echo "setting: Auto-play videos when opened with QuickTime Player"
defaults write com.apple.QuickTimePlayerX MGPlayMovieOnOpen -bool true

#endregion

###############################################################################
# Mac App Store                                                               #
###############################################################################
#region app store

printf "\e[1;34mApp Store\e[0m\n"

echo "setting: Enable the WebKit Developer Tools in the Mac App Store"
# cspell:disable-next-line
defaults write com.apple.appstore WebKitDeveloperExtras -bool true

echo "setting: Enable Debug Menu in the Mac App Store"
# cspell:disable-next-line
defaults write com.apple.appstore ShowDebugMenu -bool true

echo "setting: Enable the automatic update check"
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

echo "setting: Check for software updates daily, not just once per week"
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

echo "setting: Download newly available updates in background"
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

echo "setting: Install System data files & security updates"
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

echo "setting: Automatically download apps purchased on other Macs"
defaults write com.apple.SoftwareUpdate ConfigDataInstall -int 1

echo "setting: Turn on app auto-update"
defaults write com.apple.commerce AutoUpdate -bool true

echo "setting: Disable the App Store to reboot machine on macOS updates"
defaults write com.apple.commerce AutoUpdateRestartRequired -bool false

#endregion

###############################################################################
# Photos                                                                      #
###############################################################################

printf "\e[1;34mPhotos\e[0m\n"

echo "setting: Prevent Photos from opening automatically when devices are plugged in"
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

###############################################################################
# Messages                                                                    #
###############################################################################
#region messages

printf "\e[1;34mMessages\e[0m\n"

echo "setting: Enable automatic emoji substitution (i.e. don't use plain text smileys)"
# cspell:disable-next-line
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticEmojiSubstitutionEnablediMessage" -bool true

echo "setting: Disable smart quotes as it's annoying for messages that contain code"
# cspell:disable-next-line
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticQuoteSubstitutionEnabled" -bool false

echo "setting: Disable continuous spell checking"
# cspell:disable-next-line
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "continuousSpellCheckingEnabled" -bool false

#endregion

###############################################################################
# Google Chrome & Google Chrome Canary                                        #
###############################################################################
#region google chrome

printf "\e[1;34mGoogle Chrome\e[0m\n"

echo "setting: Disable the all too sensitive back-swipe on track pad"
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false
defaults write com.google.Chrome.canary AppleEnableSwipeNavigateWithScrolls -bool false

echo "setting: Disable the all too sensitive back-swipe on Magic Mouse"
defaults write com.google.Chrome AppleEnableMouseSwipeNavigateWithScrolls -bool false
defaults write com.google.Chrome.canary AppleEnableMouseSwipeNavigateWithScrolls -bool false

echo "setting: Use the system-native print preview dialog"
defaults write com.google.Chrome DisablePrintPreview -bool true
defaults write com.google.Chrome.canary DisablePrintPreview -bool true

echo "setting: Expand the print dialog by default"
defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true
defaults write com.google.Chrome.canary PMPrintingExpandedStateForPrint2 -bool true

#endregion

################################################################################
### Security
################################################################################
#region security

printf "\e[1;34mSecurity\e[0m\n"

echo "setting: ignore Remote Desktop/DisplayLink for PAM Touch ID"
defaults write com.apple.security.authorization ignoreArd -bool TRUE

echo "setting: enable more than one smart card/token per user"
# cspell:disable-next-line
sudo defaults write /Library/Preferences/com.apple.security.smartcard oneCardPerUser -bool false

echo "setting: enable smart card user for login and authorization"
# cspell:disable-next-line
sudo defaults write /Library/Preferences/com.apple.security.smartcard allowSmartCard -bool true

echo "setting: allow apps from anywhere"
# cspell:disable-next-line
sudo spctl --master-enable

#endregion

################################################################################
### Miscellaneous
################################################################################
#region miscellaneous

printf "\e[1;34mMiscellaneous\e[0m\n"

echo "setting: disable auto-save in AppleScript Editor"
defaults write com.apple.ScriptEditor2 ApplePersistence -bool false

echo "setting: disable library validation"
# cspell:disable-next-line
sudo defaults write /Library/Preferences/com.apple.security.libraryvalidation.plist DisableLibraryValidation -bool true

# cspell:disable-next-line
# disable system integrity protection on fs, nvram and debug
# cspell:disable-next-line
# csrutil enable --without fs --without nvram --without debug

if [ -d /System/Library/CoreServices/PowerChime.app ]; then
  printf "Disabling MacOS power chime...\n"
  defaults write com.apple.PowerChime ChimeOnAllHardware -bool false
  # cspell:disable-next-line
  killall PowerChime > /dev/null 2>&1 || true
fi

#endregion

################################################################################
### Cleanup
################################################################################

printf "\e[1;34mCleanup\e[0m\n"

printf 'do you want to kill related applications to load new defaults? [y/N] '
read -r confirm

# cspell:disable
if [ "${confirm}" = "Y" ] || [ "${confirm}" = "y" ]; then
  for app in "Activity Monitor" \
    "Address Book" \
    "Calendar" \
    "cfprefsd" \
    "Contacts" \
    "Dock" \
    "Finder" \
    "Google Chrome Canary" \
    "Google Chrome" \
    "Mail" \
    "Messages" \
    "Photos" \
    "Safari" \
    "SystemUIServer" \
    "Terminal" \
    "iCal"; do
    killall "${app}" > /dev/null 2>&1 || true
  done
fi
# cspell:enable
