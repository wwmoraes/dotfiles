require("types.hammerspoon")

local urls = require("helpers.urls")
local strings = require("helpers.strings")

local tags = require("data.tags")
local apps = require("data.apps")
local queryParams = require("data.queryParams")

---@alias Context '"work"'|'"personal"'
---@alias BrowserContext table<Context,string>

---@type table<string,BrowserContext>
local tagContextBrowser = {
  ["work"] = {
    ["personal"] = apps.Chrome,
  },
  ["personal"] = {
    ["work"] = apps.Firefox,
    ["personal"] = apps.Safari,
  },
}

---@type string
local mainContext = nil
---@type BrowserContext
local contextBrowser = nil
for _, tag in ipairs(tags) do
  mainContext = tag
  contextBrowser = tagContextBrowser[tag]
  if contextBrowser ~= nil then break end
end

local defaultBrowser = {
  main = apps.Safari,
  work = apps.Firefox,
  home = apps.Safari,
}

---@param context Context
---@return string
local function getBrowser(context)
  local contexts = contextBrowser or defaultBrowser
  return contexts[context] or contexts[mainContext]
end

---@param prefix string
---@return Rewrite
local function removePrefix(prefix)
  return {
    match = function(url)
      return strings.startsWith(url:toString(), prefix)
    end,
    url = function(url)
      return urls.unescape(strings.trimPrefix(url:toString(), prefix))
    end,
  }
end

---@param unwantedParams string[]
---@return Rewrite
local function cleanupQuery(unwantedParams)
  return {
    ---@param url URLInstance
    ---@return boolean
    match = function(url) return url.query:len() > 0 end,
    ---@param url URLInstance
    ---@return URLInstance
    url = function(url)
      -- convert query string to map
      ---@type table<string,string>
      local params = {}
      for param in url.query:gmatch("([^&]+)") do
        local name, value = param:match("([^=&]+)=([^=&]+)")
        params[name] = value
      end

      -- remove unwanted query parameters
      for _, unwanted in ipairs(unwantedParams) do
        -- easy win: the name provided is an absolute name
        if params[unwanted] ~= nil then
          params[unwanted] = nil
        else
          for name, _ in pairs(params) do
            if name:match(unwanted) == name then
              params[name] = nil
              break
            end
          end
        end
      end

      local newParamsStr = {}
      for name, value in pairs(params) do
        table.insert(newParamsStr, string.format("%s=%s", name, value))
      end
      url.query = table.concat(newParamsStr, "&")

      url:invalidate()
      return url
    end,
  }
end

hs.spoons.use("Finicky", {
  ---@type FinickyConfig
  config = {
    defaultBrowser = getBrowser(mainContext),
    handlers = {
      -- Work: Azure DevOps
      {
        host = "dev.azure.com",
        browser = apps.AzureDevOps,
      },
      -- Work: Microsoft Teams handler
      {
        host = "teams.microsoft.com",
        browser = apps.Teams,
        -- TODO override mechanism
        url = {
          scheme = "Teams"
        }
      },
      -- Work: source apps
      {
        sender = {
          apps.Slack,
          apps.Teams,
          apps.Outlook,
        },
        browser = getBrowser("work"),
      },
      -- Work: specific domains
      {
        match = { "*.abnamro.com*", "*.abnamro.org*" },
        browser = getBrowser("work"),
      },
      -- Personal: social and IM apps
      {
        sender = {
          apps.Messenger,
          apps.Telegram,
          apps.Discord,
          apps.WhatsApp,
          apps.LinkedIn,
        },
        browser = getBrowser("home"),
      },
      -- Personal: local and private domains
      {
        match = {
          "github.com/wwmoraes*",
          "*.home.localhost*",
          "*.com.br*",
          "*.thuisbezorgd.nl*",
          "*.krisp.ai*"
        },
        browser = getBrowser("home"),
      },
    },
    rewrites = {
      removePrefix("https://tracking.tldrnewsletter.com/CL0/"),
      cleanupQuery(queryParams),
    },
  },
  start = true,
  loglevel = "info",
})
---@type Finicky
spoon.Finicky = spoon.Finicky

hs.urlevent.httpCallback = hs.fnutils.partial(spoon.Finicky.open, spoon.Finicky)
