---@class Logger
---@field defaultLogLevel LogLevel
local Logger

--- returns the global log history
---@return LoggerLogEntry[]
function Logger.history()end

--- sets or gets the global log history size
---@param size number|nil @desired number of log entries to keep in the history; if omitted, will return the current size; the starting value is 0 (disabled)
---@return number @current or new history size
function Logger.historySize(size)end

--- creates a new logger instance
---@param id string @identifier for the instance
---@param loglevel LogLevel @can be 'nothing', 'error', 'warning', 'info', 'debug', or 'verbose', or a corresponding number between 0 and 5; uses hs.logger.defaultLogLevel if omitted
---@return LoggerInstance @new logger instance
function Logger.new(id, loglevel)end

--- prints the global log history to the console
---@param entries number|nil @maximum number of entries to print; if omitted, all entries in the history will be printed
---@param level LogLevel|nil @desired log level (see hs.logger:setLogLevel()); if omitted, defaults to verbose
---@param filter string|nil @string to filter the entries (by logger id or message) via string.find plain matching
---@param caseSensitive boolean|nil @if `true`, filtering is case sensitive
function Logger.printHistory(entries, level, filter, caseSensitive)end

--- sets the log level for all logger instances (including objects' loggers)
---@param lvl LogLevel @can be 'nothing', 'error', 'warning', 'info', 'debug', or 'verbose', or a corresponding number between 0 and 5
function Logger.setGlobalLogLevel(lvl)end

--- sets the log level for all currently loaded modules
---@param lvl LogLevel @can be 'nothing', 'error', 'warning', 'info', 'debug', or 'verbose', or a corresponding number between 0 and 5
function Logger.setModulesLogLevel(lvl)end
