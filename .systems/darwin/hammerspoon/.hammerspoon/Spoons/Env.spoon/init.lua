--- === Env ===
---
--- loads environment variables from dotenv-alike files, and overrides `os.getenv`
--- function to first get variables from the `Env` instance, falling back to a
--- vanilla `os.getenv` call if none is set.
---
--- This is mostly useful on MacOS 10.10+, due to the changes on launchctl and
--- its APIs to set environment variables for the graphical domain, which
--- requires the use of undocumented XPC calls to set them.
---

--- returns the short hostname from the output of the `hostname -s` command
---@return string @current hostname
local function hostname()
  local proc = io.popen("/bin/hostname -s")
  local hostname = proc:read("l") or ""
  proc:close()

  return hostname
end

---@alias ContextName '"work"' | '"personal"'

---@class Env : Spoon
--- global logger instance
---@field protected logger LoggerInstance
--- variables loaded from the files
---@field protected variables table<string,string>
--- files to load environment variables from
---@field public files string[]
--- map of short hostnames and their contexts to load extra variables from
---@field public contexts table<string,ContextName>
--- Env Spoon object
local obj = {
  variables = {},
  files = {
    os.getenv("HOME") .. "/.env",
    os.getenv("HOME") .. "/.env_secrets",
  },
  contexts = {},
}
obj.__index = obj

-- Metadata
obj.name = "Env"
obj.version = "1.0"
obj.author = "William Artero"
obj.license = "MIT - https://opensource.org/licenses/MIT"

--- global logger instance
obj.logger = hs.logger.new(string.lower(obj.name), "info")

--- loads environment variables from the given file, if it exists
---@param filename string @file path and name to load variables from
---@return Env @the Env object
function obj:loadFromFile(filename)
  local file = io.open(filename, "r")

  if file == nil then
    return self
  end

  ---@type string|nil
  for line in file:lines("l") do
    if line == nil then goto continue end
    if line:sub(1) == "#" then goto continue end

    local index = line:find("=", 1, true)
    if index == nil then goto continue end

    local name = line:sub(1, index-1)
    local value = line:sub(index+1)

    self.logger.df("%s => %s", name, value)
    self.variables[name] = value

    ::continue::
  end

  io.close(file)

  return self
end

---@return Env @the Env object
function obj:load()
  obj.variables = {}

  for i, filename in ipairs(self.files) do
    self.logger.i(string.format("loading %s...", filename))
    self:loadFromFile(filename)
  end

  return self
end

--- returns the variable value stored on this instance, if it is set, or returns
--- the value from a vanilla `os.getenv` call
---@param name string @variable name to get
---@return string|nil @the variable value or `nil`, if not set
function obj:getenv(name)
  return self.variables[name] or obj.osgetenv(name)
end

--- loads the environment files and overrides `os.getenv` function so it tries
--- to get environment variables from this `Env` instance first, falling back to
--- the original lua function if the variable is unset
---@return Env @the Env object
function obj:start()
  local thisHostname = hostname()
  local context = self.contexts[thisHostname]
  if context ~= nil then
    table.insert(self.files, os.getenv("HOME") .. "/.env_" .. context)
    table.insert(self.files, os.getenv("HOME") .. "/.env_" .. context .. "_secrets")
  end

  table.insert(self.files, os.getenv("HOME") .. "/.env-" .. thisHostname)

  obj:load()

  obj.osgetenv = os.getenv
  os.getenv = hs.fnutils.partial(self.getenv, self)

  return self
end

--- restores `os.getenv` and cleanups the loaded environment variables
---@return Env @the Env object
function obj:stop()
  os.getenv = obj.osgetenv

  obj.osgetenv = nil
  obj.variables = {}

  return self
end

return obj
