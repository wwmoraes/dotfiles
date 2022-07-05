require("types.hammerspoon")

local logger = require("helpers.logger")
local tags = require("data.tags")
local apps = require("data.apps")

hs.application.enableSpotlightForNameSearches(true)

-- named after a disabled feature from hs.host.locale
-- https://github.com/Hammerspoon/hammerspoon/blob/b03d628f792eb88188962643c32a490f1174c10d/extensions/host/locale/libhost_locale.m#L74
if hs.settings.getKeys()["timeZone"] == nil then
  logger.i("storing timezone name...")
  local output = hs.execute([[stat -f '%Y' /etc/localtime | sed -e 's@.*/zoneinfo/@@']])
  output = output:gsub("%c+", "")
  if output:len() > 0 then
    hs.settings.set("timeZone", output)
  end
end

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

require("modules.finicky")

-- ### plain init configuration

for _, tag in ipairs(tags) do
  local _, path = pcall(require, string.format("tags.%s", tag))
  logger.d(string.format("loaded %s", path))
end

-- local queryParams = require("data.queryParams")
-- hs.spoons.use("CleanURLs", {
--   ---@type CleanURLsConfig
--   config = {
--     prefixes = {
--       "https://tracking.tldrnewsletter.com/CL0/",
--     },
--     browser = hs.fnutils.partial(spoon.Finicky.open, spoon.Finicky),
--     params = queryParams,
--   },
--   start = false,
-- })
-- ---@type CleanURLs
-- spoon.CleanURLs = spoon.CleanURLs

if not hs.ipc.cliStatus() then
  logger.i("hs CLI not installed, trying to install it")
  if hs.ipc.cliInstall() then
    logger.i("hs CLI installed successfully")
  else
    logger.e("failed to install the hs CLI")
  end
end
