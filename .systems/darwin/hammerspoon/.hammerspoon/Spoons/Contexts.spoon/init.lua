--- === Contexts ===
---
--- utilities to close/open/hide groups of applications
---

--- @class Contexts : Spoon
local obj = {}
obj.__index = obj

-- Metadata
obj.name = "Contexts"
obj.version = "1.0"
obj.author = "William Artero"
obj.license = "MIT - https://opensource.org/licenses/MIT"

obj.defaultHotkeys = {
  chooser = {{"ctrl", "option", "cmd"}, "c"}
}

--- global logger instance
obj.logger = hs.logger.new(string.lower(obj.name))

--- chooser settings
obj.chooser = {
  placeholderText = "Which context you want to close?",
  choices = {},
}

--- list of apps per context
obj.contexts = {
  work = {
    title = "Work",
    applications = {
      "Firefox",
      "Slack"
    }
  }
}

--- wraps `fn` with a closure, which calls `fn` within a protected call using `pcall`, and logs the error using the `logger.e`
--- @param logger LoggerInstance
--- @param fn function
--- @vararg any
--- @return function
local function protectedPartial(logger, fn, ...)
  local partialFn = hs.fnutils.partial(fn, ...)
  return function ()
    local status, err = pcall(partialFn)
    if not status then logger.e(err) end
  end
end

--- actions available on application instances
--- @alias AppAction "'kill'" | nil

--- gracefully kill all applications within context
--- @param context string
--- @return Contexts @the Contexts object
function obj:killContext(context)
  self:doContext("kill", context)
  return self
end

--- execute the action on all applications within context
--- @param action AppAction
--- @param contextName string
--- @return Contexts @the Contexts object
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

  hs.alert.show("The applications were closed. Enjoy!")
  return self
end

--- shows a chooser to pick a context and execute the action
--- @param action AppAction
--- @return Contexts @the Contexts object
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
  chooser:placeholderText(self.chooser.placeholderText)
  chooser:choices(self.chooser.choices)
  chooser:show()
  return self
end

--- callback to process URL events from hs.urlevent
--- @param eventName string
--- @param params table
--- @return Contexts @the Contexts object
function obj:handleURLEvent(eventName, params)
  -- check if the event is contexts
  assert(eventName == string.lower(self.name), string.format("unknown event %s", eventName))
  -- get the context name
  local contextName = assert(params.name, "no context name provided")
  -- get the interactive flag, or default to true
  local interactive = true
  if params.interactive ~= nil and params.interactive == "false" then
    interactive = false
  end

  local information = string.format("Close all %s-related applications?", contextName)

  if interactive then
    -- create the notification
    hs.notify.new(
      function() self:killContext(contextName) end,
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
    self:killContext(contextName)
  end

  return self
end

--- @param mapping HotkeyMapping table of strings that describe bindable actions of the spoon, with hotkey spec values
--- @return Contexts @the Contexts object
function obj:bindHotkeys(mapping)
  local def = {
    chooser = protectedPartial(
      self.logger, self.contextChooser, self, "kill"
    ),
  }
  hs.spoons.bindHotkeysToSpec(def, mapping)
  return self
end

--- @return Contexts @the Contexts object
function obj:start()
  self.chooser.choices = {}
  for contextName, _ in pairs(self.contexts) do
    local text = self.contexts[contextName].title or contextName
    table.insert(self.chooser.choices, {
      text = text,
      context = contextName,
    })
  end

  hs.urlevent.bind(string.lower(self.name), function(...)
    local status, err = pcall(self.handleURLEvent, self, ...)
    if not status then self.logger.e(err) end
  end)

  return self
end

--- @return Contexts @the Contexts object
function obj:stop()
  hs.urlevent.bind(string.lower(self.name), nil)
  return self
end

return obj
