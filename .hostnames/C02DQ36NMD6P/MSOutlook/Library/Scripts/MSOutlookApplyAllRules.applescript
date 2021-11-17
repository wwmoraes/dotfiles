-- based on https://stackoverflow.com/a/21977155
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
		-- Old Outlook interface, which has the Apply All rules option. Pure love.
		if exists menu item "Apply All" of menu 1 of menu item "Apply" of menu 1 of menu item "Rules" of menu 1 of menu bar item "Message" of menu bar 1 then
			click menu item "Apply All" of menu 1 of menu item "Apply" of menu 1 of menu item "Rules" of menu 1 of menu bar item "Message" of menu bar 1
		else -- New Outlook interface, which doesn't have an Apply All rules option, forcing us to run each rule at a time LOL
			-- open the rules window if needed
			if not (exists window "Rules") then
				log "opening rules window…"
				click menu item "Edit Rules…" of menu 1 of menu item "Rules" of menu 1 of menu bar item "Message" of menu bar 1
			end if
			set rulesWindow to window "Rules"
			
			-- wait for the rules window to load all rules
			repeat while exists static text "Loading Rules..." of rulesWindow
				log "waiting rules to be loaded…"
				delay 1
			end repeat
			
			-- get all "run rule now" buttons
			log "rules loaded! getting buttons…"
			set btns to (get button 1 of group 1 of every group of UI element 1 of scroll area 1 of group 1 of group 1 of rulesWindow)
			log "executing rules…"
			repeat with btn in btns
				-- only tries to click if the rule is ready to run
				if (get help of btn) is equal to "Run rule now" then
					log "clicking button: " & (get description of btn)
					click btn
				end if
				
				-- we need to fucking wait the rule execution on New Outlook
				-- thank you so much MSFT for removing the apply all option
				log "waiting rule to finish…"
				repeat while (get help of btn) is not equal to "Run rule now"
					delay 2
				end repeat
			end repeat
			
			-- close rules window
			log "closing rules window…"
			click button 1 of rulesWindow
		end if
	end tell
end tell
log "done!"
