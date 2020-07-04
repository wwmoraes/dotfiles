#!/bin/sh

# don’t blink the caret (the value is in milliseconds)
# defaults write NSTextInsertionPointBlinkPeriod -int 9999999999999999

# use a lighter text rendering style
defaults write AppleFontSmoothing -int 1

# disable the animations for opening Quick Look windows
defaults write QLPanelAnimationDuration -float 0

# display ASCII control characters in caret notation
defaults write NSTextShowsControlCharacters -bool true

# disable checking spelling while typing
defaults write NSAllowContinuousSpellChecking -bool false

# disable auto-save in AppleScript Editor
defaults write com.apple.ScriptEditor2 ApplePersistence -bool false

### dock
# faster exposé animations
defaults write com.apple.dock expose-animation-duration -float 0.12
# remove dock autohide delay
defaults write com.apple.Dock autohide-delay -float 0
# show translucent icons for hidden apps
defaults write com.apple.Dock showhidden -bool yes
killall Dock

### Finder
# enable text selection on QuickLook
defaults write com.apple.finder QLEnableTextSelection -bool true
killall Finder

### Mail
# copy email only
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

### misc
# always show the user Library folder
chflags nohidden ~/Library/

# MacForge - disable library validarion
sudo defaults write /Library/Preferences/com.apple.security.libraryvalidation.plist DisableLibraryValidation -bool true

# MacForge - disable system integrity protection on fs, nvram and debug
csrutil enable --without fs --without nvram --without debug
