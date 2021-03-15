---@class Spoons
local Spoons

--- map a number of hotkeys according to a definition table
---@param def HotkeyDefinitions @table containing name-to-function definitions for the hotkeys supported by the Spoon. Each key is a hotkey name, and its value must be a function that will be called when the hotkey is invoked.
---@param map HotkeyMapping @table containing name-to-hotkey definitions and an optional message to be displayed via hs.alert() when the hotkey has been triggered, as supported by bindHotkeys in the Spoon API. Not all the entries in def must be bound, but if any keys in map don't have a definition, an error will be produced.
function Spoons.bindHotkeysToSpec(def, map)end

--- check if a given Spoon is installed
---@param name string @name of the Spoon to check
---@return SpoonInfo @returns the Spoon information if installed, `nil` otherwise
function Spoons.isInstalled(name)end

--- check if a given Spoon is loaded
---@param name string @name of the Spoon to check
---@return boolean|nil @`true` if the Spoon is loaded, `nil` otherwise
function Spoons.isLoaded(name)end

--- return a list of installed/loaded Spoons
---@param onlyLoaded boolean|nil @only return loaded Spoons (skips those that are installed but not loaded). Defaults to `false`
---@return SpoonInfo[] @list of installed/loaded spoons
function Spoons.list(onlyLoaded)end

--- create a skeleton for a new Spoon
---@param name string @name of the new spoon, without the `.spoon` extension
---@param basedir string|nil @directory where to create the template. Defaults to `~/.hammerspoon/Spoons`
---@param metadata SpoonTemplateMetadata|nil @metadata values to be inserted in the template. Provided values are merged with the defaults
---@param template string|nil @absolute path of the template to use for the `init.lua` file of the new Spoon. Defaults to the `templates/init.tpl` file included with Hammerspoon
---@return string|nil @the full directory path where the template was created, or `nil` if there was an error.
function Spoons.newSpoon(name, basedir, metadata, template)end

--- return full path of an object within a spoon directory, given its partial path
---@param partial string @path of a file relative to the Spoon directory. For example images/img1.png will refer to a file within the images directory of the Spoon
---@return string @absolute path of the file. Note: no existence or other checks are done on the path.
function Spoons.resourcePath(partial)end

--- return path of the current spoon
---@param n number|nil @stack level for which to get the path. Defaults to 2, which will return the path of the spoon which called scriptPath()
---@return string @string with the path from where the calling code was loaded
function Spoons.scriptPath(n)end

--- declaratively load and configure a Spoon
---@param name string @name of the Spoon to load (without the .spoon extension)
---@param arg SpoonConfiguration|nil @if provided, can be used to specify the configuration of the Spoon
---@param noerror boolean|nil @if `true`, don't log an error if the Spoon is not installed
---@return boolean|nil @`true` if the spoon was loaded, `nil` otherwise
function Spoons.use(name, arg, noerror)end
