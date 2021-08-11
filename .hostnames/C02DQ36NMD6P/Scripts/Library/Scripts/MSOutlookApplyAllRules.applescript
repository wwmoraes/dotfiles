-- https://stackoverflow.com/a/21977155
tell application "Microsoft Outlook"
    activate
    if main windows is {} then -- no windows open
        make new main window
    end if

    tell main window 1 to set view to mail view -- ensure its viewing mail

    set the selected folder to inbox
end tell

tell application "System Events"
    tell process "Microsoft Outlook"
        click menu item "Apply All" of menu 1 of menu item "Apply" of menu 1 of menu item "Rules" of menu 1 of menu bar item "Message" of menu bar 1
    end tell
end tell
