--- @alias LogLevelName "'nothing'"|"'error'"|"'warning'"|"'info'"|"'debug'"|"'verbose'"
--- @alias LogLevelNumber '0'|'1'|'2'|'3'|'4'|'5'
--- @alias LogLevel LogLevelName|LogLevelNumber

--- @class LogEntry
--- @field public time number @timestamp in seconds since the epoch
--- @field public level LogLevelNumber @number between 1 (error) and 5 (verbose)
--- @field public id string @string containing the id of the logger instance that produced this entry
--- @field public message string @string containing the logged message

--- @class LoggerInstance
--- @field public level LogLevelNumber @log level of this instance
local LoggerInstance

--- logs debug info to the console
--- @vararg string
function LoggerInstance.d(...)end

--- logs formatted debug info to the console
--- @param fmt string @formatting string as per string.format
--- @vararg string
function LoggerInstance.df(fmt, ...)end

--- logs error to the console
--- @vararg string
function LoggerInstance.e(...)end

--- logs formatted error to the console
--- @param fmt string @formatting string as per string.format
--- @vararg string
function LoggerInstance.ef(fmt, ...)end

--- logs formatted info to the console
--- @param fmt string @formatting string as per string.format
--- @vararg string
function LoggerInstance.f(fmt, ...)end

--- logs info to the console
--- @vararg string
function LoggerInstance.i(...)end

--- gets the log level of the logger instance
--- @return LogLevelNumber @The log level of this logger as a number
function LoggerInstance.getLoggerLevel()end

--- sets the log level of the logger instance
--- @param loglevel LogLevel @can be 'nothing', 'error', 'warning', 'info', 'debug', or 'verbose'; or a corresponding number between 0 and 5
function LoggerInstance.setLoggerLevel(loglevel)end

--- logs verbose info to the console
--- @vararg string
function LoggerInstance.v(...)end

--- logs formatted verbose info to the console
--- @param fmt string @formatting string as per string.format
--- @vararg string
function LoggerInstance.vf(fmt, ...)end

--- logs warning to the console
--- @vararg string
function LoggerInstance.w(...)end

--- logs formatted warning to the console
--- @param fmt string @formatting string as per string.format
--- @vararg string
function LoggerInstance.wf(fmt, ...)end

--- @class Logger
--- @field defaultLogLevel LogLevel
local Logger

--- returns the global log history
--- @return LogEntry[]
function Logger.history()end

--- sets or gets the global log history size
--- @param size number|nil @desired number of log entries to keep in the history; if omitted, will return the current size; the starting value is 0 (disabled)
--- @return number @current or new history size
function Logger.historySize(size)end

--- creates a new logger instance
--- @param id string @identifier for the instance
--- @param loglevel LogLevel @can be 'nothing', 'error', 'warning', 'info', 'debug', or 'verbose', or a corresponding number between 0 and 5; uses hs.logger.defaultLogLevel if omitted
--- @return LoggerInstance @new logger instance
function Logger.new(id, loglevel)end

--- prints the global log history to the console
--- @param entries number|nil @maximum number of entries to print; if omitted, all entries in the history will be printed
--- @param level LogLevel|nil @desired log level (see hs.logger:setLogLevel()); if omitted, defaults to verbose
--- @param filter string|nil @string to filter the entries (by logger id or message) via string.find plain matching
--- @param caseSensitive boolean|nil @if `true`, filtering is case sensitive
function Logger.printHistory(entries, level, filter, caseSensitive)end

--- sets the log level for all logger instances (including objects' loggers)
--- @param lvl LogLevel @can be 'nothing', 'error', 'warning', 'info', 'debug', or 'verbose', or a corresponding number between 0 and 5
function Logger.setGlobalLogLevel(lvl)end

--- sets the log level for all currently loaded modules
--- @param lvl LogLevel @can be 'nothing', 'error', 'warning', 'info', 'debug', or 'verbose', or a corresponding number between 0 and 5
function Logger.setModulesLogLevel(lvl)end
