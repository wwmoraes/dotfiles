require("types.hammerspoon")

local logger = hs.logger.new("init", "info")
local tags = require("data.tags")
local apps = require("data.apps")

---### third-party spoons configuration

hs.loadSpoon("SpoonInstall")
---@type SpoonInstall
spoon.SpoonInstall = spoon.SpoonInstall
spoon.SpoonInstall.repos.wwmoraes = {
  url = "https://github.com/wwmoraes/spoons",
  desc = "wwmoraes' spoons",
  branch = "release",
}

spoon.SpoonInstall:andUse("ReloadConfiguration", {
  config = {
    watch_paths = {
      hs.configdir,
      os.getenv("HOME") .. "/.files/.systems/darwin/hammerspoon/.hammerspoon"
    },
  },
  start = true,
})

---### development spoons configuration

hs.spoons.use("Env", {
  start = true,
})
---@type Env
spoon.Env = spoon.Env

local apps = {
  Blisk = "org.blisk.blisk",
  Brave = "com.brave.browser",
  BraveBeta = "com.brave.browser.beta",
  BraveDev = "com.brave.browser.dev",
  ChromeCanary = "com.google.chrome.canary",
  Edge = "com.microsoft.edgemac",
  EdgeBeta = "com.microsoft.edgemac.beta",
  FirefoxDeveloperEdition = "org.mozilla.firefoxdeveloperedition",
  Opera = "com.operasoftware.opera",
  Vivaldi = "com.vivaldi.vivaldi",
  Wavebox = "com.bookry.wavebox",
  Teams = "com.microsoft.teams",
  Outlook = "com.microsoft.Outlook",
  OneDrive = "OneDrive",
  Amethyst = "com.amethyst.Amethyst",
  VSCode = "com.microsoft.vscode",
  Kitty = "net.kovidgoyal.kitty",
  AzureDevOps = "com.fluidapp.FluidApp2.AzureDevOps",
  LinkedIn = "com.fluidapp.FluidApp2.LinkedIn",
  Safari = "com.apple.Safari",
  Chrome = "com.google.Chrome",
  Firefox = "org.mozilla.firefox",
  VSCodium = "com.visualstudio.code.oss",
  Slack = "com.tinyspeck.slackmacgap",
  Messenger = "com.facebook.archon",
  WhatsApp = "WhatsApp",
  Discord = "com.hnc.Discord",
  Telegram = "ru.keepcoder.Telegram",
}

hs.spoons.use("Contexts", {
  ---@type ContextsConfig
  config = {
    contexts = {
      work = {
        title = "Work",
        openAt = "09:00",
        closeAt = "17:00",
        hostnames = {
          ["M1Cabuk"] = false,
        },
        exceptDays = {
          [1] = true,
          [7] = true
        },
        applications = {
          apps.Teams,
          apps.Outlook,
          apps.OneDrive,
          apps.AzureDevOps,
        },
      },
      development = {
        title = "Development",
        applications = {
          apps.VSCodium,
          apps.Kitty,
        }
      },
    },
    onWake = {
      open = {
        apps.amethyst
      },
    },
    onSleep = {
      kill = {
        apps.Amethyst
      },
    },
  },
  hotkeys = "default",
  start = true,
})
---@type Contexts
spoon.Contexts = spoon.Contexts

hs.spoons.use("Meetings", {
  config = {
    calendarURL = os.getenv("MEETINGS_CALENDAR_URL") or "",
    dailyScheduleTime = "09:00",
    browserBundleID = "org.mozilla.firefox",
  },
  hotkeys = "default",
  start = true,
})
---@type Meetings
spoon.Meetings = spoon.Meetings

hs.spoons.use("Hazel", {
  config = {
    rulesets = {
      [os.getenv("HOME") .. "/Downloads/aws-credentials"] = {
        function(path, flags) return flags.itemCreated end,
        function(path, flags) return flags.itemIsFile end,
        function(path, flags)
          local f = io.open(path, "r")
          return f ~= nil and io.close(f)
        end,
        ---@param path string
        ---@param flags PathwatcherFlags
        function(path, flags)
          local status, err = os.rename(path, os.getenv("HOME") .. "/.aws/credentials")
          if status then return true end
          logger.e(err)
          return false
        end,
      },
      [os.getenv("HOME") .. "/Downloads"] = {
        function(path, flags)
          return path:match(".*/.TheUnarchiverTemp0") and flags.itemIsDir == true
        end,
        function(path, flags)
          return path:match(".*/.TheUnarchiverTemp0/.*")
        end,
        function(path, flags)
          return flags.itemModified or flags.itemRemoved
        end,
        function(path, flags)
          if path:match('%.zip$') then
            hs.task.new("/usr/bin/open", nil, nil, { path }):start()
            return true
          end
          return false
        end
      },
    },
  },
  start = true,
})
---@type Hazel
spoon.Hazel = spoon.Hazel

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
-- ### plain init configuration

---@type string
local mainContext = nil
---@type BrowserContext
local contextBrowser = nil
for _, tag in ipairs(tags) do
  mainContext = tag
  contextBrowser = tagContextBrowser[tag]
  if contextBrowser ~= nil then break end
  local success, err = pcall(dofile, string.format("tags/%s.lua", tag))
  if success == false then
    logger.d(err)
  end
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
local function prefixRemover(prefix)
  return {
    match = function(url)
      return url:toString():find(prefix) == 1
    end,
    url = function(url)
      return url:toString():sub(string.len(prefix) + 1)
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
      prefixRemover("https://tracking.tldrnewsletter.com/CL0/"),
      -- TODO remove query params
    },
  },
  start = true,
  loglevel = "verbose",
})
---@type Finicky
spoon.Finicky = spoon.Finicky

hs.urlevent.httpCallback = hs.fnutils.partial(spoon.Finicky.open, spoon.Finicky)

-- hs.spoons.use("CleanURLs", {
--   ---@type CleanURLsConfig
--   config = {
--     prefixes = {
--       "https://tracking.tldrnewsletter.com/CL0/",
--     },
--     params = {
--       -- web tracking parameters
--       "__hs.*", -- HubSpot
--       "__s", -- Drip.com
--       "_bta_.*", -- Bronto
--       "_ga", -- Google Analytics
--       "_hs.*", -- HubSpot
--       "_ke", -- Klaviyo
--       "_openstat", -- Yandex
--       "auto_subscribed",
--       "dclid", -- Google
--       "dm_i", -- dotdigital
--       "ef_id", -- Adobe Advertising Cloud
--       "email_source",
--       "epik", -- Pinterest
--       "fbclid", -- Facebook
--       "gclid", -- Google AdWords/Analytics
--       "gdf.*", -- GoDataFeed
--       "gclsrc", -- Google DoubleClick
--       "hsa_.*", -- HubSpot
--       "hsCtaTracking", -- HubSpot
--       "igshid", -- Instagram
--       "matomo_.*", -- Matomo
--       "mc_.*", -- MailChimp
--       "mkt_.*", -- Adobe Marketo
--       "mkwid", -- Marin
--       "ml_.*", -- MailerLite
--       "msclkid", -- Microsoft Advertising
--       "mtm_.*", -- Matomo
--       "oly_.*", -- Omeda
--       "pcrid", -- Marin
--       "piwik_.*", -- Piwik
--       "pk_.*", -- Piwik
--       "rb_clickid", -- Unknown high-entropy
--       "redirect_log_mongo_id", -- Springbot
--       "redirect_mongo_id", -- Springbot
--       "s_cid", -- Adobe Site Catalyst
--       "s_kwcid", -- Adobe Analytics
--       "sb_referer_host", -- Springbot
--       "trk_.*", -- Listrak
--       "uta_.*",
--       "utm_.*", -- Google Analytics
--       "vero_.*", -- Vero
--       "wickedid", -- Wicked Reports
--       "yclid", -- Yandex click ID
--     },
--     browser = hs.fnutils.partial(spoon.Finicky.open, spoon.Finicky),
--   },
--   start = false,
-- })
-- ---@type CleanURLs
-- spoon.CleanURLs = spoon.CleanURLs
