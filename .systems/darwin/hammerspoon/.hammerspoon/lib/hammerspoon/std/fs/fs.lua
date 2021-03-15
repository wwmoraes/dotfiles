---@class Fs
---@field volume Volume
local Fs

--- Gets the attributes of a file
---
---@param filepath string @path of a file to inspect
---@param aName string|nil @if specified, only the value of an attribute with that name is returned
---@return FsAttributes|string|nil,string|nil @either a table with `filepath` attributes, nil and an error message or, if `aName` is given, a string with the attribute value
function Fs.attributes(filepath, aName)end

--- Changes the current working directory to the given path
---
---@param path string @path to change working directory to
---@return boolean|nil,string|nil @returns `true` if successful, otherwise `nil` and an error message
function Fs.chdir(path)end

--- Gets the current working directory
---
---@return string|nil,string|nil @current working directory if successful, otherwise `nil` and an error message
function Fs.currentDir()end

--- Creates an iterator for walking a filesystem path
---
--- Notes:
---
--- * Unlike most functions in this module, `hs.fs.dir` will throw a Lua error
--- if the supplied `path` cannot be iterated.
--- * The simplest way to use this function is with a `for` loop, which will
--- take care of closing the directory stream for you, even if you break out of
--- the loop early.
---
---@param path string @directory to iterate
---@return FsDirIterator,FsDirData|string,nil,FsDirData
function Fs.dir(path)end
