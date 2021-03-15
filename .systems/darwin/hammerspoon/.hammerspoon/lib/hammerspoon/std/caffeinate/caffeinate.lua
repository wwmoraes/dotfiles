--- Control system power states (sleeping, preventing sleep, screen locking, etc)
---@class Caffeinate
---@field watcher CaffeinateWatcher
local Caffeinate

--- Fetches information about processes which are currently asserting
--- display/power sleep restrictions
---
---@return table @information about current power assertions, with process IDs
--- (PID) as the keys, each of which may contain multiple assertions
function Caffeinate.currentAssertions()end

--- Informs the OS that the user performed some activity
---
--- Notes:
---
--- * This is intended to simulate user activity, for example to prevent displays from sleeping, or to wake them up
--- * It is not mandatory to re-use assertion IDs if you are calling this function mulitple times, but it is recommended that you do so if the calls are related
---
---@param id number|nil @assertion ID from a previous call
---@return number @generated assertion ID
function Caffeinate.declareUserActivity(id)end

--- Show the Fast User Switch screen (ie a login screen without logging out first)
---
function Caffeinate.fastUserSwitch()end

--- Queries whether a particular sleep type is being prevented
---
---@param sleepType CaffeinateSleepTypes @type of sleep to inspect (see `hs.caffeinate.set()` for information about the possible values)
---@return boolean|nil @`true` if the specified type of sleep is being prevented, `false` if not. `nil` if `sleepType` was an invalid value
function Caffeinate.get(sleepType)end


--- Locks the displays
---
--- Notes:
---
--- * This function uses private Apple APIs and could therefore stop working in any given release of macOS without warning.
---
function Caffeinate.lockScreen()end

--- Request the system log out the current user
---
function Caffeinate.logOut()end

--- Request the system reboot
---
function Caffeinate.restartSystem()end

--- Fetches information from the display server about the current session
---
--- Notes:
---
--- * The keys in this dictionary will vary based on the current state of the system (e.g. local vs VNC login, screen locked vs unlocked).
---
---@return table|nil @ information about the current session, or nil if an error occurred
---
function Caffeinate.sessionProperties()end

--- Configures the sleep prevention settings
---
--- Notes:
---
--- * These calls are not guaranteed to prevent the system sleep behaviours described above. The OS may override them if it feels it must (e.g. if your CPU temperature becomes dangerously high).
--- * The `acAndBattery` argument only applies to the `system` sleep type.
--- * You can toggle the `acAndBattery` state by calling `hs.caffeinate.set()` again and altering the `acAndBattery` value.
--- * The `acAndBattery` option does not appear to work anymore - it is based on private API that is not allowed in macOS 10.15 when running with the Hardened Runtime (which Hammerspoon now uses).
---
--- Sleep types:
---
--- * `displayIdle` - Controls whether the screen will be allowed to sleep (and also the system) if the user is idle.
--- * `systemIdle` - Controls whether the system will be allowed to sleep if the user is idle (display may still sleep).
--- * `system` - Controls whether the system will be allowed to sleep for any reason.
---
---@param sleepType CaffeinateSleepTypes @type of sleep to be configured
---@param aValue boolean @`true` if the specified type of sleep should be prevented, `false` if it should be allowed
---@param acAndBattery boolean @`true` if the sleep prevention should apply to both AC power and battery power, `false` if it should only apply to AC power
---
function Caffeinate.set(sleepType, aValue, acAndBattery)end

--- Request the system log out and power down
---
function Caffeinate.shutdownSystem()end

--- Request the system start the screensaver (which may lock the screen if the OS is configured to do so)
---
function Caffeinate.startScreensaver()end

--- Requests the system to sleep immediately
---
function Caffeinate.systemSleep()end

--- Toggles the current state of the specified type of sleep
---
--- Notes:
---
--- * If `systemIdle` is toggled to on, it will apply to AC only
---
---@param sleepType CaffeinateSleepTypes @type of sleep to toggle (see `hs.caffeinate.set()` for information about the possible values)
---@return boolean|nil @`true` if the specified type of sleep is being prevented, `false` if not. `nil` if `sleepType` was an invalid value
---
function Caffeinate.toggle(sleepType)end
