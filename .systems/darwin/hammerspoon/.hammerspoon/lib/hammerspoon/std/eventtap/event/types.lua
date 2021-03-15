---@alias EventTapEventTypeNameMouse '"leftMouseDown"'|'"leftMouseUp"'|'"rightMouseDown"'|'"rightMouseUp"'|'"mouseMoved"'|'"leftMouseDragged"'|'"rightMouseDragged"'|'"mouseEntered"'|'"mouseExited"'

---@alias EventTapEventTypeName '"nullEvent"'|EventTapEventTypeNameMouse|'"keyDown"'|'"keyUp"'|'"flagsChanged"'|'"appKitDefined"'|'"systemDefined"'|'"applicationDefined"'|'"periodic"'|'"cursorUpdate"'|'"rotate"'|'"scrollWheel"'|'"tabletPointer"'|'"tabletProximity"'|'"otherMouseDown"'|'"otherMouseUp"'|'"otherMouseDragged"'|'"gesture"'|'"magnify"'|'"swipe"'|'"smartMagnify"'|'"quickLook"'|'"pressure"'|'"directTouch"'|'"changeMode"'

---@alias EventTapEventType EventTapEventTypeName|integer

---@alias EventTapEventKeyModifier '"cmd"'|'"alt"'|'"shift"'|'"ctrl"'|'"fn"'

---@alias EventTapEventKeyModifierUnicode '"⌘"'|'"⌥"'|'"⇧"'|'"⌃"'

---@alias EventTapEventKeyModifierFlag EventTapEventKeyModifier|EventTapEventKeyModifierUnicode

---@alias EventTapEventModifier EventTapEventKeyModifier|'"rightCmd"'|'"rightAlt"'|'"rightShift"'|'"rightCtrl"'

---@alias EventTapEventGestureType '"beginMagnify"'|'"endMagnify"'|'"beginRotate"'|'"endRotate"'|'"beginSwipeLeft"'|'"endSwipeLeft"'|'"beginSwipeRight"'|'"endSwipeRight"'|'"beginSwipeUp"'|'"endSwipeUp"'|'"beginSwipeDown"'|'"endSwipeDown"'

---@alias EventTapEventSpecialKeyName '"SOUND_UP"'|'"SOUND_DOWN"'|'"MUTE"'|'"BRIGHTNESS_UP"'|'"BRIGHTNESS_DOWN"'|'"CONTRAST_UP"'|'"CONTRAST_DOWN"'|'"POWER"'|'"LAUNCH_PANEL"'|'"VIDMIRROR"'|'"PLAY"'|'"EJECT"'|'"NEXT"'|'"PREVIOUS"'|'"FAST"'|'"REWIND"'|'"ILLUMINATION_UP"'|'"ILLUMINATION_DOWN"'|'"ILLUMINATION_TOGGLE"'|'"CAPS_LOCK"'|'"HELP"'|'"NUM_LOCK"'
