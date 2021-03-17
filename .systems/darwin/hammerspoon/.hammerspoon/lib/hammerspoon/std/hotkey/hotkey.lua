--- Create and manage global keyboard shortcuts
---@class Hotkey
--- Duration of the alert shown when a hotkey created with a message parameter is triggered, in seconds. Default is 1.
---@field alertDuration number
local Hotkey

--- Determines whether the hotkey combination can be assigned a callback
---
--- Notes:
---
--- The most common reason a hotkey combination cannot be given an assignment by
--- is because it is in use by the Mac operating system -- see the Shortcuts tab
--- of Keyboard in the System Preferences application or
--- `hs.hotkey.systemAssigned`.
---
---@param mods HotkeyModifier[]|string @list or string containing (as elements, or as substrings with any separator) the keyboard modifiers
---@param key string|number @name of a keyboard key (as found in `hs.keycodes.map`), or a raw keycode number
---@return boolean @`true` if the hotkey can be assigned, `false` otherwise
function Hotkey.assignable(mods, key)end

---@param mods HotkeyModifier[]|string
---@param key string|number
---@param message string|nil
---@param pressedfn function|nil
---@param releasedfn function|nil
---@param repeatfn function|nil
---@return HotkeyInstance
function Hotkey.bind(mods, key, message, pressedfn, releasedfn, repeatfn)end
