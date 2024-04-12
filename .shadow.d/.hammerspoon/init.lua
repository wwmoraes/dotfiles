pcall(require, "types.hammerspoon")

hs.notify.withdrawAll()

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
---@diagnostic disable-next-line: assign-type-mismatch
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

spoon.SpoonInstall:andUse("Env", {
  start = true,
  repo = "wwmoraes",
})
---@type Env
---@diagnostic disable-next-line: assign-type-mismatch
spoon.Env = spoon.Env

spoon.SpoonInstall:andUse("Contexts", {
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
          apps.Edge,
          apps.VSCode,
          apps.Kitty,
          apps.Keeper,
          apps.XBar,
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
        apps.Amethyst,
      },
    },
    onSleep = {
      kill = {
        apps.Amethyst,
        apps.AMM,
      },
    },
  },
  hotkeys = "default",
  start = true,
  repo = "wwmoraes",
})
---@type Contexts
---@diagnostic disable-next-line: assign-type-mismatch
spoon.Contexts = spoon.Contexts

-- spoon.SpoonInstall:andUse("Meetings", {
--   config = {
--     calendarURL = os.getenv("MEETINGS_CALENDAR_URL") or "",
--     dailyScheduleTime = "09:00",
--     browserBundleID = "org.mozilla.firefox",
--   },
--   hotkeys = "default",
--   start = true,
--   repo = "wwmoraes",
-- })
-- ---@type Meetings
-- ---@diagnostic disable-next-line: assign-type-mismatch
-- spoon.Meetings = spoon.Meetings

spoon.SpoonInstall:andUse("Hazel", {
  ---@type HazelConfig
  config = {
    ruleSets = {
      [os.getenv("HOME") .. "/Downloads/aws-credentials"] = {
        ---@param path string
        ---@param flags PathwatcherFlags
        function(path, flags) return flags.itemCreated end,
        ---@param path string
        ---@param flags PathwatcherFlags
        function(path, flags) return flags.itemIsFile end,
        ---@param path string
        ---@param flags PathwatcherFlags
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
        ---@param path string
        ---@param flags PathwatcherFlags
        function(path, flags)
          return path:match(".*/.TheUnarchiverTemp0") and flags.itemIsDir == true
        end,
        ---@param path string
        ---@param flags PathwatcherFlags
        function(path, flags)
          return path:match(".*/.TheUnarchiverTemp0/.*")
        end,
        ---@param path string
        ---@param flags PathwatcherFlags
        function(path, flags)
          return flags.itemModified or flags.itemRemoved
        end,
        ---@param path string
        ---@param flags PathwatcherFlags
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
  repo = "wwmoraes",
})
---@type Hazel
---@diagnostic disable-next-line: assign-type-mismatch
spoon.Hazel = spoon.Hazel

-- require("modules.finicky")

-- ### plain init configuration

for _, tag in ipairs(tags) do
  local _, path = pcall(require, string.format("tags.%s", tag))
  logger.d(string.format("loaded %s", path))
end

-- if not hs.ipc.cliStatus() then
--   logger.i("hs CLI not installed, trying to install it")
--   if hs.ipc.cliInstall() then
--     logger.i("hs CLI installed")
--   else
--     logger.e("failed to install the hs CLI")
--   end
-- end
