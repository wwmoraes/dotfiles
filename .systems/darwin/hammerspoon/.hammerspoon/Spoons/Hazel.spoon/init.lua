--- === Hazel ===
---
--- watches path changes to execute actions on them
---

--- callback to process a pair of path and flags from a pathwatcher event.
--- Should return `true` if the event was consumed and stop rule parsing for it
---@alias RuleFn "function(path:string, flags:Flags): boolean"

---@class Hazel : Spoon
--- global logger instance
---@field protected logger LoggerInstance
--- system events watcher
---@field protected watchers CaffeinateWatcher[]
--- set of paths and its rules
---@field public rulesets table<string,RuleFn[]>
--- Hazel Spoon object
local obj = {
  watchers = {}
}
obj.__index = obj

-- Metadata
obj.name = "Hazel"
obj.version = "1.0"
obj.author = "William Artero"
obj.license = "MIT - https://opensource.org/licenses/MIT"

obj.logger = hs.logger.new(string.lower(obj.name), 'verbose')

---@param paths string[]
---@param flagTables table<string,PathwatcherFlags>
---@return Hazel @the Hazel object
function obj:execute(paths, flagTables)
  self.logger.i("executing rules for ".. hs.json.encode(paths, false))
  for index, path in pairs(paths) do
    -- local rules = self.rulesets[path]
    -- if #rules > self.rulesets[path] then
      -- for _, rule in ipairs(rules) do
      for _, rule in ipairs(self.rulesets[path]) do
        if rule(path, flagTables[index]) == false then return self end
      end
    -- end
  end

  return self
end

---@return Contexts @the Contexts object
function obj:start()
  for path, rules in pairs(self.rulesets) do
    if #rules > 0 then
      table.insert(self.watchers, hs.pathwatcher.new(
        path,
        hs.fnutils.partial(obj.execute, obj)
      ):start())
      self.logger.i("watcher set for "..path)
    end
  end

  return self
end

---@return Contexts @the Contexts object
function obj:stop()
  while #self.watchers > 0 do
    table.remove(self.watchers, #self.watchers):stop()
  end

  return self
end

return obj
