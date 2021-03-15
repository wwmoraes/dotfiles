--- Creates recursive path watchers that triggers on changes
---@class Pathwatcher
local Pathwatcher

--- Creates a new path watcher object
---
---@param path string @path to be watched
---@param fn PathwatcherFn @function to be called when changes are detected
---@return PathwatcherInstance @an `PathwatcherInstance` object
function Pathwatcher.new(path, fn)end
