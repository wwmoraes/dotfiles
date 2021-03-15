---@class LoggerInstance
---@field public level LogLevelNumber @log level of this instance
local LoggerInstance

--- logs debug info to the console
---@vararg string
function LoggerInstance.d(...)end

--- logs formatted debug info to the console
---@param fmt string @formatting string as per string.format
---@vararg string
function LoggerInstance.df(fmt, ...)end

--- logs error to the console
---@vararg string
function LoggerInstance.e(...)end

--- logs formatted error to the console
---@param fmt string @formatting string as per string.format
---@vararg string
function LoggerInstance.ef(fmt, ...)end

--- logs formatted info to the console
---@param fmt string @formatting string as per string.format
---@vararg string
function LoggerInstance.f(fmt, ...)end

--- logs info to the console
---@vararg string
function LoggerInstance.i(...)end

--- gets the log level of the logger instance
---@return LogLevelNumber @The log level of this logger as a number
function LoggerInstance.getLoggerLevel()end

--- sets the log level of the logger instance
---@param loglevel LogLevel @can be 'nothing', 'error', 'warning', 'info', 'debug', or 'verbose'; or a corresponding number between 0 and 5
function LoggerInstance.setLoggerLevel(loglevel)end

--- logs verbose info to the console
---@vararg string
function LoggerInstance.v(...)end

--- logs formatted verbose info to the console
---@param fmt string @formatting string as per string.format
---@vararg string
function LoggerInstance.vf(fmt, ...)end

--- logs warning to the console
---@vararg string
function LoggerInstance.w(...)end

--- logs formatted warning to the console
---@param fmt string @formatting string as per string.format
---@vararg string
function LoggerInstance.wf(fmt, ...)end
