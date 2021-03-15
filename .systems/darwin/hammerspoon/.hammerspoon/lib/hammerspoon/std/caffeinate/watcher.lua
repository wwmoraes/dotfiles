--- Watch for display and system sleep/wake/power events and for fast user
--- switching session events
---@class CaffeinateWatcher
--- The system woke from sleep
---@field systemDidWake number
--- The system is preparing to sleep
---@field systemWillSleep number
--- The user requested a logout or shutdown
---@field systemWillPowerOff number
--- The displays have gone to sleep
---@field screensDidSleep number
--- The displays have woken from sleep
---@field screensDidWake number
--- The session is no longer active, due to fast user switching
---@field sessionDidResignActive number
--- The session became active, due to fast user switching
---@field sessionDidBecomeActive number
--- The screensaver started
---@field screensaverDidStart number
--- The screensaver is about to stop
---@field screensaverWillStop number
--- The screensaver stopped
---@field screensaverDidStop number
--- The screen was locked
---@field screensDidLock number
--- The screen was unlocked
---@field screensDidUnlock number
local CaffeinateWatcher

--- logs debug info to the console
---
---@param fn function @function that will be called when system/display events happen
---@return CaffeinateWatcher
function CaffeinateWatcher.new(fn)end

--- starts the sleep/wake watcher
---
---@return CaffeinateWatcher
function CaffeinateWatcher:start()end

--- stops the sleep/wake watcher
---
---@return CaffeinateWatcher
function CaffeinateWatcher:stop()end
