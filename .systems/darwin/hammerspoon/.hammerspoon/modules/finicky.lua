require("types.hammerspoon")

local urls = require("helpers.urls")
local strings = require("helpers.strings")

local tags = require("data.tags")
local apps = require("data.apps")
local queryParams = require("data.queryParams")

---@alias Context '"work"'|'"home"'
---@alias BrowserContext table<Context,string|table<string>>

---@type table<string,BrowserContext>
local tagContextBrowser = {
  ["work"] = {
    ["work"] = apps.Edge,
    ["home"] = apps.Firefox,
  },
  ["home"] = {
    ["work"] = apps.Firefox,
    ["home"] = apps.Safari,
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

---@type table<string,string|table<string>>
local defaultBrowser = {
  main = apps.Safari,
  work = apps.Firefox,
  home = apps.Safari,
}

---@param context Context
---@return string|table<string>
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
    match = function(url) return type(url.query) == "string" and url.query:len() > 0 end,
    ---@param url URLInstance
    ---@return URLInstance
    url = function(url)
      local params = spoon.Finicky.parseQuery(url.query)

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
      -- Home: social and IM apps
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
      -- Development
      {
        host = "github.com",
        browser = getBrowser("home"),
      },
      -- Home: local and private domains
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
      {
        ---@param url URLInstance
        ---@return boolean
        match = function(url)
          return strings.endsWith(url.host, "safelinks.protection.outlook.com")
        end,
        ---@param url URLInstance
        ---@return string|URLInstance
        url = function(url)
          local params = spoon.Finicky.parseQuery(url.query)
          return spoon.Finicky.decodeURIComponent(params["url"])
        end,
      },
      {
        match = function(url)
          return url.host == "confluence.aws.abnamro.org"
        end,
        url = function(url)
          url.host = "confluence.int.abnamro.com"
          return url
        end,
      }
    },
  },
  start = true,
  loglevel = "info",
})
---@type Finicky
spoon.Finicky = spoon.Finicky

hs.urlevent.httpCallback = hs.fnutils.partial(spoon.Finicky.open, spoon.Finicky)
