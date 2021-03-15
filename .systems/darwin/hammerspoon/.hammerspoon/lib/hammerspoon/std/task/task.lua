--- Execute processes in the background and capture their output
---
--- Notes:
---
--- * This is not intended to be used for processes which never exit. While it
--- is possible to run such things with `hs.task`, it is not possible to read
--- their output while they run and if they produce significant output,
--- eventually the internal OS buffers will fill up and the task will be suspended.
--- * An `hs.task` object can only be used once
---
---@class Task
local Task

--- Creates a new `hs.task` object
---
--- Notes:
---
--- * The arguments are not processed via a shell, so you do not need to do any quoting or escaping. They are passed to the executable exactly as provided.
--- * When using a stream callback, the callback may be invoked one last time
--- after the termination callback has already been invoked. In this case, the
--- `task` argument to the stream callback will be `nil` rather than the task
--- userdata object and the return value of the stream callback will be ignored.
---
---@param launchPath string @path to an executable file. This must be the full path to an executable and not just an executable which is in your environment's path (e.g. `/bin/ls` rather than just `ls`).
---@param callbackFn TaskCallback|nil @callback function to be called when the task terminates, or `nil` if no callback should be called
---@param streamCallbackFn TaskStreamCallback|nil @callback function to be called whenever the task outputs data to stdout or stderr
---@param arguments string[]|nil @command line arguments for the executable
---@return TaskInstance @an `hs.task` object
function Task.new(launchPath, callbackFn, streamCallbackFn, arguments)end
