--- @alias HotkeyDefinitions table<string,function>

--- @class SpoonTemplateMetadata : SpoonMetadata
--- @field download_url string

--- @class SpoonInfo
--- @field name string
--- @field loaded boolean
--- @field version string

--- @alias SpoonConfigurationCallback "function(obj:Spoon)"

--- @class SpoonConfiguration
--- @field public config table @a table containing variables to be stored in the Spoon object to configure it. For example, config = { answer = 42 } will result in spoon.<LoadedSpoon>.answer being set to 42.
--- @field public hotkeys HotkeyMapping|"default" @a table containing hotkey bindings. If provided, will be passed as-is to the Spoon's bindHotkeys() method. The special string "default" can be given to use the Spoons defaultHotkeys variable, if it exists.
--- @field public fn SpoonConfigurationCallback @function which will be called with the freshly-loaded Spoon object as its first argument
--- @field public loglevel number @if the Spoon has a variable called logger, its setLogLevel() method will be called with this value.
--- @field public start boolean @if `true`, call the Spoon's `start()` method after configuring everything else

--- @class Spoons
local Spoons

--- map a number of hotkeys according to a definition table
--- @param def HotkeyDefinitions @table containing name-to-function definitions for the hotkeys supported by the Spoon. Each key is a hotkey name, and its value must be a function that will be called when the hotkey is invoked.
--- @param map HotkeyMapping @table containing name-to-hotkey definitions and an optional message to be displayed via hs.alert() when the hotkey has been triggered, as supported by bindHotkeys in the Spoon API. Not all the entries in def must be bound, but if any keys in map don't have a definition, an error will be produced.
function Spoons.bindHotkeysToSpec(def, map)end

--- check if a given Spoon is installed
--- @param name string @name of the Spoon to check
--- @return SpoonInfo @returns the Spoon information if installed, `nil` otherwise
function Spoons.isInstalled(name)end

--- check if a given Spoon is loaded
--- @param name string @name of the Spoon to check
--- @return boolean|nil @`true` if the Spoon is loaded, `nil` otherwise
function Spoons.isLoaded(name)end

--- return a list of installed/loaded Spoons
--- @param onlyLoaded boolean|nil @only return loaded Spoons (skips those that are installed but not loaded). Defaults to `false`
--- @return SpoonInfo[] @list of installed/loaded spoons
function Spoons.list(onlyLoaded)end

--- create a skeleton for a new Spoon
--- @param name string @name of the new spoon, without the `.spoon` extension
--- @param basedir string|nil @directory where to create the template. Defaults to `~/.hammerspoon/Spoons`
--- @param metadata SpoonTemplateMetadata|nil @metadata values to be inserted in the template. Provided values are merged with the defaults
--- @param template string|nil @absolute path of the template to use for the `init.lua` file of the new Spoon. Defaults to the `templates/init.tpl` file included with Hammerspoon
--- @return string|nil @the full directory path where the template was created, or `nil` if there was an error.
function Spoons.newSpoon(name, basedir, metadata, template)end

--- return full path of an object within a spoon directory, given its partial path
--- @param partial string @path of a file relative to the Spoon directory. For example images/img1.png will refer to a file within the images directory of the Spoon
--- @return string @absolute path of the file. Note: no existence or other checks are done on the path.
function Spoons.resourcePath(partial)end

--- return path of the current spoon
--- @param n number|nil @stack level for which to get the path. Defaults to 2, which will return the path of the spoon which called scriptPath()
--- @return string @string with the path from where the calling code was loaded
function Spoons.scriptPath(n)end

--- declaratively load and configure a Spoon
--- @param name string @name of the Spoon to load (without the .spoon extension)
--- @param arg SpoonConfiguration|nil @if provided, can be used to specify the configuration of the Spoon
--- @param noerror boolean|nil @if `true`, don't log an error if the Spoon is not installed
--- @return boolean|nil @`true` if the spoon was loaded, `nil` otherwise
function Spoons.use(name, arg, noerror)end
