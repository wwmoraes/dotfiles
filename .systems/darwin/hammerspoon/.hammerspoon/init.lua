require("types.hammerspoon")

local logger = hs.logger.new("init", "info")

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
  msEdge = "com.microsoft.edgemac",
  msTeams = "com.microsoft.teams",
  msOutlook = "com.microsoft.Outlook",
  oneDrive = "OneDrive",
  amethyst = "com.amethyst.Amethyst",
  vscode = "com.microsoft.vscode",
  kitty = "net.kovidgoyal.kitty",
  fluidADO = "com.fluidapp.FluidApp2.AzureDevOps",
  appleSafari = "com.apple.Safari",
  vscodium = "com.visualstudio.code.oss",
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
          apps.msEdge,
          apps.msTeams,
          apps.msOutlook,
          apps.oneDrive,
          apps.fluidADO,
        },
      },
      development = {
        title = "Development",
        applications = {
          apps.vscodium,
          apps.kitty,
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
        apps.amethyst
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

hs.spoons.use("CleanURLs", {
  ---@type CleanURLsConfig
  config = {
    prefixes = {
      "https://tracking.tldrnewsletter.com/CL0/",
    },
    params = {
      -- web tracking parameters
      "__hs.*", -- HubSpot
      "__s", -- Drip.com
      "_bta_.*", -- Bronto
      "_ga", -- Google Analytics
      "_hs.*", -- HubSpot
      "_ke", -- Klaviyo
      "_openstat", -- Yandex
      "auto_subscribed",
      "dclid", -- Google
      "dm_i", -- dotdigital
      "ef_id", -- Adobe Advertising Cloud
      "email_source",
      "epik", -- Pinterest
      "fbclid", -- Facebook
      "gclid", -- Google AdWords/Analytics
      "gdf.*", -- GoDataFeed
      "gclsrc", -- Google DoubleClick
      "hsa_.*", -- HubSpot
      "hsCtaTracking", -- HubSpot
      "igshid", -- Instagram
      "matomo_.*", -- Matomo
      "mc_.*", -- MailChimp
      "mkt_.*", -- Adobe Marketo
      "mkwid", -- Marin
      "ml_.*", -- MailerLite
      "msclkid", -- Microsoft Advertising
      "mtm_.*", -- Matomo
      "oly_.*", -- Omeda
      "pcrid", -- Marin
      "piwik_.*", -- Piwik
      "pk_.*", -- Piwik
      "rb_clickid", -- Unknown high-entropy
      "redirect_log_mongo_id", -- Springbot
      "redirect_mongo_id", -- Springbot
      "s_cid", -- Adobe Site Catalyst
      "s_kwcid", -- Adobe Analytics
      "sb_referer_host", -- Springbot
      "trk_.*", -- Listrak
      "uta_.*",
      "utm_.*", -- Google Analytics
      "vero_.*", -- Vero
      "wickedid", -- Wicked Reports
      "yclid", -- Yandex click ID
    },
    browser = apps.appleSafari,
  },
  start = true,
})
---@type CleanURLs
spoon.CleanURLs = spoon.CleanURLs

-- ### plain init configuration

--- reads the tags from the current host tagsrc file
--- @return table<string,boolean>
local function getTags()
  local tagsrc = os.getenv("TAGSRC") or os.getenv("HOME") .. "/.tagsrc"
  local tags = {}
  local fd, err = io.open(tagsrc)
  if err ~= nil then
    return tags
  end

  for tag in fd:lines() do
    table.insert(tags, tag)
  end
  fd:close()

  return tags
end

local tags = getTags()
for _, tag in ipairs(tags) do
  local success, err = pcall(dofile, string.format("tags/%s.lua", tag))
  if success == false then
    logger.d(err)
  end
end
