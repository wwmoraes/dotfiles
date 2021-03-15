---@class LoggerLogEntry
---@field public time number @timestamp in seconds since the epoch
---@field public level LogLevelNumber @number between 1 (error) and 5 (verbose)
---@field public id string @string containing the id of the logger instance that produced this entry
---@field public message string @string containing the logged message
