pcall(require, "types.hammerspoon")

hs.notify.withdrawAll()

local logger = require("helpers.logger")
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

---@class RuntimeSpoons
---@field SpoonInstall SpoonInstall
---@field Env Env
---@field Contexts Contexts

hs.loadSpoon("SpoonInstall")

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
          apps.Teams2,
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
        [apps.Amethyst] = {},
        [apps.StreamDeck] = {
          arguments = { "--runinbk" },
        },
      },
    },
    onSleep = {
      kill = {
        apps.Amethyst,
        apps.AMM,
        apps.StreamDeck,
      },
    },
  },
  hotkeys = "default",
  start = true,
  repo = "wwmoraes",
})

-- ### plain init configuration

local environment = os.getenv("ENVIRONMENT")
if environment ~= "" then
  local _, path = pcall(require, string.format("environment.%s", environment))
  logger.d(string.format("loaded %s", path))
else
  logger.w("no ENVIRONMENT set")
end

if not hs.ipc.cliStatus() then
  logger.i("hs CLI not installed, trying to install it")
  if hs.ipc.cliInstall() then
    logger.i("hs CLI installed")
  else
    logger.e("failed to install the hs CLI")
  end
end
