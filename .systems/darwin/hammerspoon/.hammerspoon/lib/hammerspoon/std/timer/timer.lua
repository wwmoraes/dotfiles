---@class Timer
---@field delayed Delayed
local Timer

--- returns the absolute time in nanoseconds since the last system boot
---
--- Notes:
--- * this value does not include time that the system has spent asleep
--- * this value is used for the timestamps in system generated events.
---
---@return number @time since the last system boot in nanoseconds
function Timer.absoluteTime()end

--- converts days to seconds
---@param n number @number of days
---@return number @seconds in `n` days
function Timer.days(n)end

--- converts hours to seconds
---@param n number @number of hours
---@return number @seconds in `n` hours
function Timer.hours(n)end

--- returns the number of seconds since local time midnight
---@return number @seconds since local midnight
function Timer.localTime()end

--- converts minutes to seconds
---@param n number @number of minutes
---@return number @seconds in `n` minutes
function Timer.minutes(n)end

--- converts a string with a time of day or a duration into number of seconds
---
--- Notes:
--- * time must be 24-hour and can be formatted as either "HH:MM:SS" or "HH:MM"
--- * duration can be formatted as "DDdHHh", "HHhMMm", "MMmSSs", "DDd", "HHh", "MMm", "SSs" or "NNNNms"
---
---@param timeOrDuration string @string with either time or duration
---@return number @seconds in `timeOrDuration`
function Timer.seconds(timeOrDuration)end

--- returns the (fractional) number of seconds since the UNIX epoch (January 1, 1970).
---
--- Notes:
---
--- This has much better precision than os.time(), which is limited to whole seconds
---@return number @seconds since the epoch
function Timer.secondsSinceEpoch()end

--- blocks Lua execution for the specified time.
---
--- Notes:
--- * use of this function is strongly discouraged, as it blocks all main-thread execution in Hammerspoon. This means no hotkeys or events will be processed in that time, no GUI updates will happen, and no Lua will execute. This is only provided as a last resort, or for extremely short sleeps. For all other purposes, you really should be splitting up your code into multiple functions and calling `hs.timer.doAfter()`
---
---@param microsecs number @time in microseconds to block for
function Timer.usleep(microsecs)end

--- converts weeks to seconds
---@param n number @number of weeks
---@return number @seconds in `n` weeks
function Timer.weeks(n)end

--- calls a function after a delay
---
--- Notes:
--- * There is no need to call `:start()` on the returned object, the timer will be already running.
--- * The callback can be cancelled by calling the `:stop()` method on the returned object before sec seconds have passed.
---
---@param sec number @seconds to wait before calling the function
---@param fn function @function to call
---@return TimerInstance @a timer object
function Timer.doAfter(sec, fn)end

--- creates and starts a timer which will perform `fn` at the given (local)
--- `time` and then (optionally) repeat it every `repeatInterval`.
---
--- Notes:
--- * The timer can trigger up to 1 second early or late
--- * The first trigger will be set to the earliest occurrence given the repeatInterval; if that's omitted, and time is earlier than the current time, the timer will trigger the next day. If the repeated interval results in exactly 24 hours you can schedule regular jobs that will run at the expected time independently of when Hammerspoon was restarted/reloaded. E.g.:
---   * If it's 19:00, hs.timer.doAt("20:00",somefn) will set the timer 1 hour from now
---   * If it's 21:00, hs.timer.doAt("20:00",somefn) will set the timer 23 hours from now
---   * If it's 21:00, hs.timer.doAt("20:00","6h",somefn) will set the timer 5 hours from now (at 02:00)
---   * To run a job every hour on the hour from 8:00 to 20:00: for h=8,20 do hs.timer.doAt(h..":00","1d",runJob) end
---
---@param time number @seconds after (local) midnight, or a string in the format "HH:MM" (24-hour local time), indicating the desired trigger time
---@param repeatInterval number|string @seconds between triggers, or a string in the format "DDd", "DDdHHh", "HHhMMm", "HHh" or "MMm" indicating days, hours and/or minutes between triggers; if omitted or 0 the timer will trigger only once
---@param fn function @function to call every time the timer triggers
---@param continueOnError boolean|nil @if true, timer will not stop if the callback function results in an error
---@return TimerInstance @a timer object
function Timer.doAt(time, repeatInterval, fn, continueOnError)end

--- repeats `fn` every interval seconds
---
--- Notes:
--- * This function is a shorthand for `hs.timer.new(interval, fn):start()`
---
---@param interval number @seconds between triggers
---@param fn function @function to call every time the timer triggers
---@return TimerInstance @a timer object
function Timer.doEvery(interval, fn)end

--- creates and starts a timer which will perform `actionFn` every
--- `checkinterval` seconds until `predicateFn` returns `true`. The timer is
--- automatically stopped when `predicateFn` returns `true`
---
--- Notes:
--- * The timer is passed as an argument to `actionFn` so that it may stop the
--- timer prematurely (i.e. before `predicateFn` returns `true`) if desired.
--- * See also `hs.timer.doWhile`, which is essentially the opposite of this
---
---@param predicateFn "function():boolean" @function which determines when to stop calling actionFn. This function takes no arguments, but should return `true` when it is time to stop calling actionFn.
---@param actionFn "function(timer:TimerInstance)" @function which performs the desired action. This function may take a single argument, the timer itself.
---@param checkInterval number|nil @indicates how often to repeat the `predicateFn` check (defaults to 1 second)
---@return TimerInstance @a timer object
function Timer.doUntil(predicateFn, actionFn, checkInterval)end

--- creates and starts a timer which will perform `actionFn` every
--- `checkinterval` seconds while `predicateFn` returns true. The timer is
--- automatically stopped when `predicateFn` returns `false`.
---
--- Notes:
--- * The timer is passed as an argument to `actionFn` so that it may stop the
--- timer prematurely (i.e. before `predicateFn` returns `false`) if desired.
--- * See also `hs.timer.doUntil`, which is essentially the opposite of this
---
---@param predicateFn "function():boolean" @function which determines when to stop calling actionFn. This function takes no arguments, but should return `false` when it is time to stop calling actionFn.
---@param actionFn "function(timer:TimerInstance)" @function which performs the desired action. This function may take a single argument, the timer itself.
---@param checkInterval number|nil @indicates how often to repeat the `predicateFn` check (defaults to 1 second)
---@return TimerInstance @a timer object
function Timer.doWhile(predicateFn, actionFn, checkInterval)end

--- creates a new `hs.timer` instance for repeating interval callbacks
---
--- Notes:
--- * The returned object does not start its timer until its `:start()` method
--- is called
--- * If `interval` is 0, the timer will not repeat (because if it did, it would
--- be repeating as fast as your machine can manage, which seems generally unwise)
--- * For non-zero intervals, the lowest acceptable value for the interval is
--- 0.00001s. Values >0 and <0.00001 will be coerced to 0.00001
---
---@param interval number @seconds between firings of the timer
---@param fn function @function to call every time the timer fires
---@param continueOnError boolean @if `true`, the timer will continue to be triggered after the callback function has produced an error (defaults to `false`)
---@return TimerInstance @a timer object
function Timer.new(interval, fn, continueOnError)end

--- creates and starts a timer which will perform `actionFn` when `predicateFn`
--- returns `true`. The timer is automatically stopped when `actionFn` is called
---
--- Notes:
--- * The timer is stopped before `actionFn` is called, but the timer is passed
--- as an argument to `actionFn` so that the `actionFn` may restart the timer to
--- be called again the next time `predicateFn` returns `true`
--- * See also `hs.timer.waitWhile`, which is essentially the opposite of this function
---
---@param predicateFn "function():boolean" @function which determines when to stop calling `actionFn`. This function takes no arguments, but should return `true` when it is time to stop calling `actionFn`.
---@param actionFn "function(timer:TimerInstance)" @function which performs the desired action. This function may take a single argument, the timer itself.
---@param checkInterval number|nil @indicates how often to repeat the `predicateFn` check (defaults to 1 second)
---@return TimerInstance @a timer object
function Timer.waitUntil(predicateFn, actionFn, checkInterval)end

--- creates and starts a timer which will perform `actionFn` when `predicateFn`
--- returns `false`. The timer is automatically stopped when `actionFn` is called
---
--- Notes:
--- * The timer is stopped before `actionFn` is called, but the timer is passed
--- as an argument to `actionFn` so that the `actionFn` may restart the timer to
--- be called again the next time `predicateFn` returns `false`
--- * See also `hs.timer.waitUntil`, which is essentially the opposite of this function
---
---@param predicateFn "function():boolean" @function which determines when to stop calling `actionFn`. This function takes no arguments, but should return `false` when it is time to stop calling `actionFn`.
---@param actionFn "function(timer:TimerInstance)" @function which performs the desired action. This function may take a single argument, the timer itself.
---@param checkInterval number|nil @indicates how often to repeat the `predicateFn` check (defaults to 1 second)
---@return TimerInstance @a timer object
function Timer.waitWhile(predicateFn, actionFn, checkInterval)end
