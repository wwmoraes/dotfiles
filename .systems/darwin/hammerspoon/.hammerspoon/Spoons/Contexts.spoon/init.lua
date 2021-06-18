--- === Contexts ===
---
--- close/open/hide groups of applications based on contexts
---
--- there's a built-in switcher that can be used with ^ + ⌥ + ⌘ + C, unless
--- overridden
---
--- there's also timers that run on 9am and 5pm to ask to open and close,
--- respectively, the work context
---

---@class ContextEntry
--- context title used on notifications and on the chooser
---@field title string
--- optional time string on when to emit the notification to open the context
---@field openAt string|nil
--- optional time string on when to emit the notification to close the context
---@field closeAt string|nil
--- rules to enable/disable the timers per hostname (default true for all hosts)
---@field hostnames table<string,boolean>|nil
--- days to skip the scheduled open/close
---@field exceptDays table<number,boolean>|nil
--- list of application names or bundle IDs to interact with
---@field applications string[]

---@class Contexts : Spoon
--- global logger instance
---@field protected logger LoggerInstance
--- list of timers created to notify about openning and closing contexts at
--- certain times
---@field protected timers TimerInstance[]
--- list of choices available on the chooser
---@field protected choices table
--- chooser placeholder text shown on the input box
---@field public chooserPlaceholderText string
--- context details to use throughout the module
---@field public contexts ContextEntry[]
--- map of system events to functions to execute
---@field public eventCallback table<number,function>
--- system events watcher
---@field protected watcher CaffeinateWatcher
--- Contexts Spoon object
local obj = {
  timers = {},
  choices = {},
  chooserPlaceholderText = "Which context you want to %s?",
  contexts = {
    ---@type ContextEntry
    work = {
      title = "Work",
      openAt = "09:00",
      closeAt = "17:00",
      ---@type table<number,boolean>
      exceptDays = {
        [1] = true,
        [7] = true
      },
      applications = {
        "Slack"
      }
    },
    development = {
      title = "Development",
      applications = {
        "com.microsoft.vscode",
        "net.kovidgoyal.kitty"
      }
    }
  }
}
obj.__index = obj

-- Metadata
obj.name = "Contexts"
obj.version = "1.0"
obj.author = "William Artero"
obj.license = "MIT - https://opensource.org/licenses/MIT"

obj.eventName = {
  [0] = "systemDidWake",
  [1] = "systemWillSleep",
  [2] = "systemWillPowerOff",
  [3] = "screensDidSleep",
  [4] = "screensDidWake",
  [5] = "sessionDidResignActive",
  [6] = "sessionDidBecomeActive",
  [7] = "screensaverDidStart",
  [8] = "screensaverWillStop",
  [9] = "screensaverDidStop",
  [10] = "screensDidLock",
  [11] = "screensDidUnlock",
}

---@type HotkeyMapping
obj.defaultHotkeys = {
  killChooser = {{"ctrl", "option", "cmd"}, "k"},
  hideChooser = {{"ctrl", "option", "cmd"}, "h"},
  openChooser = {{"ctrl", "option", "cmd"}, "o"},
}

obj.logger = hs.logger.new(string.lower(obj.name), "info")

--- wraps `fn` with a closure, which calls `fn` within a protected call using `pcall`, and logs the error using the `logger.e`
---@param logger LoggerInstance
---@param fn function
---@vararg any
---@return function
local function protectedPartial(logger, fn, ...)
  local partialFn = hs.fnutils.partial(fn, ...)
  return function ()
    local status, err = pcall(partialFn)
    if not status then logger.e(err) end
  end
end

--- callback that fires the context switch action if not on `exceptDays`
---@param context ContextEntry
---@param contextName string
---@param baseURL string
---@param action string
local function doAtCallback(context, contextName, baseURL, action)
  if context.exceptDays ~= nil and context.exceptDays[os.date("*t").wday] then
    return
  end

  hs.urlevent.openURL(string.format("%s?name=%s&action=%s", baseURL, contextName, action))
end

--- returns the short hostname from the output of the `hostname -s` command
---@return string @current hostname
local function hostname()
  local proc = io.popen("/bin/hostname -s")
  local hostname = proc:read("l") or ""
  proc:close()

  return hostname
end

--- processes caffeinate watcher events
---@param eventType number
function obj:processEvent(eventType)
  local eventName = self.eventName[eventType]
  local fn = self.eventCallback[eventType]
  if fn == nil then
    self.logger.i("no handler registered for event", eventName)
    return
  end

  self.logger.f("executing %s handler", eventName)
  fn(self)
end

--- actions available on application instances
---@alias AppAction "'kill'" | "'open'" | "'hide'" | nil

--- gracefully kill all applications within context
---@param context string
---@return Contexts @the Contexts object
function obj:killContext(context)
  self:doContext("kill", context)
  return self
end

--- execute the action on all applications within context
---@param action AppAction
---@param contextName string
---@return Contexts @the Contexts object
function obj:doContext(action, contextName)
  assert(action, "no action provided")
  assert(type(action) == "string", "action must be a string")
  assert(contextName, "no context provided")
  assert(type(contextName) == "string", "context must be a string")
  local context = assert(self.contexts[contextName], string.format("context %s does not exist", contextName))
  local appNames = assert(context.applications, string.format("context %s has no applications set", contextName))

  -- TODO refactor action handling
  if action == "open" then
    for _, appName in ipairs(appNames) do
      hs.application.open(appName)
    end
  else
    for _, appName in ipairs(appNames) do
      local app = hs.application(appName)
      if app ~= nil and app[action] and type(app[action]) == "function" then
        app[action](app)
      end
    end
  end

  hs.alert.show(string.format("%s executed for %s applications", action, contextName))
  return self
end

--- shows a chooser to pick a context and execute the action
---@param action AppAction
---@return Contexts @the Contexts object
function obj:contextChooser(action)
  local action = action or "kill"
  local completionFn = function(choice)
    -- noop if the chooser is dismissed
    if choice == nil then
      obj.logger.i("no choice made")
      return
    end

    assert(choice.context, "choice has no context set")

    self:doContext(action, choice.context)
  end
  local chooser = hs.chooser.new(completionFn)
  chooser:placeholderText(string.format(self.chooserPlaceholderText, action))
  chooser:choices(self.choices)
  chooser:show()
  return self
end

--- callback to process URL events from hs.urlevent
---@param eventName string
---@param params table
---@return Contexts @the Contexts object
function obj:handleURLEvent(eventName, params)
  -- check if the event is contexts
  assert(eventName == string.lower(self.name), string.format("unknown event %s", eventName))
  -- get the context name
  local contextName = assert(params.name, "no context provided")
  -- get the action name
  local action = assert(params.action, "no action provided")
  -- get the interactive flag, or default to true
  local interactive = true
  if params.interactive ~= nil and params.interactive == "false" then
    interactive = false
  end

  if interactive then
    -- create the notification
    local information = string.format("%s all %s-related applications?", action, contextName)
    hs.notify.new(
      function() self:doContext(action, contextName) end,
      {
        title = self.name,
        subTitle = contextName,
        informativeText = information,
        withdrawAfter = 0,
        hasActionButton = true,
        actionButtonTitle = "Yes",
        otherButtonTitle = "Not yet"
      }):send()
  else
    self:doContext(action, contextName)
  end

  return self
end

---@param mapping HotkeyMapping table of strings that describe bindable actions of the spoon, with hotkey spec values
---@return Contexts @the Contexts object
function obj:bindHotkeys(mapping)
  local def = {
    killChooser = protectedPartial(
      self.logger, self.contextChooser, self, "kill"
    ),
    hideChooser = protectedPartial(
      self.logger, self.contextChooser, self, "hide"
    ),
    openChooser = protectedPartial(
      self.logger, self.contextChooser, self, "open"
    ),
  }
  hs.spoons.bindHotkeysToSpec(def, mapping)
  return self
end

--- create choice entries based on current contexts, using the title field value
--- as chooser text, if present, or the context name itself otherwise
---@return Contexts @the Contexts object
function obj:generateChoices()
  self.choices = {}
  for contextName, _ in pairs(self.contexts) do
    local text = self.contexts[contextName].title or contextName
    table.insert(self.choices, {
      text = text,
      context = contextName,
    })
  end

  return self
end

--- setup context timers
---@return Contexts @the Contexts object
function obj:setupTimers()
  local baseURL = "hammerspoon://"..string.lower(self.name)
  local host = hostname()

  ---@param contextName string
  ---@param context ContextEntry
  for contextName, context in pairs(self.contexts) do
    -- do not enable the timers on hosts explicitly listed as false
    if context.hostnames[host] ~= false then
      if context.openAt ~= nil then
        table.insert(self.timers, hs.timer.doAt(
          context.openAt,
          "1d",
          hs.fnutils.partial(doAtCallback, context, contextName, baseURL, "open"),
          true
        ))
      end

      if context.closeAt ~= nil then
        table.insert(self.timers, hs.timer.doAt(
          context.closeAt,
          "1d",
          hs.fnutils.partial(doAtCallback, context, contextName, baseURL, "kill"),
          true
        ))
      end
    end
  end

  self.logger.i("timers set up successfully")
  return self
end

--- stop and remove context timers
---@return Contexts @the Contexts object
function obj:cleanupTimers()
  while #self.timers > 0 do
    table.remove(self.timers, #self.timers):stop()
  end

  self.logger.i("timers cleaned up successfully")
  return self
end

---@return Contexts @the Contexts object
function obj:init()
  self:generateChoices()

  self.watcher = hs.caffeinate.watcher.new(hs.fnutils.partial(self.processEvent, self))
  self.eventCallback = {
    [hs.caffeinate.watcher.systemDidWake] = hs.fnutils.partial(self.setupTimers, self),
    [hs.caffeinate.watcher.systemWillSleep] = hs.fnutils.partial(self.cleanupTimers, self),
    [hs.caffeinate.watcher.systemWillPowerOff] = hs.fnutils.partial(self.cleanupTimers, self),
  }

  return self
end

---@return Contexts @the Contexts object
function obj:start()
  -- bind URL event
  local eventName = string.lower(self.name)
  hs.urlevent.bind(eventName, function(...)
    local status, err = pcall(self.handleURLEvent, self, ...)
    if not status then self.logger.e(err) end
  end)

  -- setup context timers
  self:setupTimers()

  -- starts the system events watcher
  self.watcher:start()

  return self
end

---@return Contexts @the Contexts object
function obj:stop()
  -- unbind URL event
  hs.urlevent.bind(string.lower(self.name), nil)

  -- cleanup context timers
  self:cleanupTimers()

  -- stops the system events watcher
  self.watcher:stop()

  return self
end

return obj
