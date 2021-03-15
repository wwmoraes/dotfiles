--- Specialized timer objects to coalesce processing of unpredictable asynchronous events into a single callback
---@class Delayed
local Delayed

--- Creates a new delayed timer
---
--- Delayed timers have specialized methods that behave differently from regular
--- timers. When the `:start()` method is invoked, the timer will wait for
--- `delay` seconds before calling `fn()`; this is referred to as the callback
--- countdown. If `:start()` is invoked again before `delay` has elapsed, the
--- countdown starts over again.
---
--- You can use a delayed timer to coalesce processing of unpredictable
--- asynchronous events into a single callback; for example, if you have an
--- event stream that happens in "bursts" of dozens of events at once, set an
--- appropriate `delay` to wait for things to settle down, and then your
--- callback will run just once.
---
--- Notes:
--- * these timers are meant to be long-lived: once instantiated, there's no way
--- to remove them from the run loop; create them once at the module level.
---
---@param delay number @seconds to wait for after a `:start()` invocation (the "callback countdown")
---@param fn function @function to call after `delay` has fully elapsed without any further `:start()` invocations
---@return DelayedInstance @a delayed timer object
function Delayed.new(delay, fn)end
