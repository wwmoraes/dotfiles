--- An `hs.task` object
---@class TaskInstance
local TaskInstance

--- Closes the task's stdin
---
--- Notes:
---
--- * This should only be called on tasks with a streaming callback - tasks
--- without it will automatically close stdin when any data supplied via
--- `hs.task:setInput()` has been written
--- * This is primarily useful for sending EOF to long-running tasks
---
---@return TaskInstance @the `hs.task` object
function TaskInstance:closeInput()end

--- Returns the environment variables as a table for the task.
---
--- Notes:
---
--- * if you have not yet set an environment table with the
--- `hs.task:setEnvironment` method, this method will return a copy of the
--- Hammerspoon environment table, as this is what the task will inherit by
--- default.
---
---@return table<string,string> @table where each key is the environment variable name
function TaskInstance:environment()end

---@return TaskInstance @the `hs.task` object
function TaskInstance:interrupt()end

---@return boolean @`true` if the task is running, `false` otherwise
function TaskInstance:isRunning()end

---@return boolean
function TaskInstance:pause()end

---@return number
function TaskInstance:pid()end

---@return boolean
function TaskInstance:resume()end

---@param fn TaskCallback|nil
---@return TaskInstance
function TaskInstance:setCallback(fn)end

---@param environment table<string,string>
---@return TaskInstance|'false'
function TaskInstance:setEnvironment(environment)end

---@param inputData string
---@return TaskInstance
function TaskInstance:setInput(inputData)end

---@param fn TaskStreamCallback|nil
---@return TaskInstance
function TaskInstance:setStreamingCallback(fn)end

---@param path string
---@return TaskInstance|'false'
function TaskInstance:setWorkingDirectory(path)end

---@return TaskInstance|'false'
function TaskInstance:start()end

---@return TaskInstance
function TaskInstance:terminate()end

---@return '"exit"'|'"interrupt"'|'false'
function TaskInstance:terminationReason()end

---@return number|'false'
function TaskInstance:terminationStatus()end

---@return TaskInstance
function TaskInstance:waitUntilExit()end

---@return string
function TaskInstance:workingDirectory()end
