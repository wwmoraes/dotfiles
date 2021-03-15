---@class DelayedInstance
local DelayedInstance

--- returns the time left in the callback countdown
---
---@return number|nil @returns the seconds until it triggers, otherwise `nil`
function DelayedInstance:nextTrigger()end

--- returns a boolean indicating whether the callback countdown is running
---
---@return boolean @`true` if the countdown is running, `false` otherwise
function DelayedInstance:running()end

--- changes the callback countdown duration
---
--- Notes:
--- * if the callback countdown is running, calling this method will restart it
---
---@param delay number @countdown duration in seconds
---@return DelayedInstance @this delayed timer object
function DelayedInstance:setDelay(delay)end

--- starts or restarts the callback countdown
---
---@param delay number|nil @sets the countdown duration to this number of seconds; subsequent calls to `:start()` will revert to the original `delay` (or to the `delay` set with `:setDelay(delay)`)
---@return DelayedInstance @this delayed timer object
function DelayedInstance:start(delay)end

--- cancels the callback countdown, if running; the callback will therefore not
--- be triggered
---
---@return DelayedInstance @this delayed timer object
function DelayedInstance:stop()end
