require("lib.hammerspoon")

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
  config = {
    ---@type table<string,ContextName>
    contexts = {
      ["M1Cabuk"] = "personal",
      ["C02DQ36NMD6P"] = "work",
    },
  },
  start = true,
})
---@type Env
spoon.Env = spoon.Env

hs.spoons.use("Contexts", {
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
          "Firefox",
          "Microsoft Teams",
          "Microsoft Outlook",
          "OneDrive"
        },
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
        function (path, flags)
          return path:match(".*/.TheUnarchiverTemp0/.*")
        end,
        function (path, flags)
          return flags.itemModified or flags.itemRemoved
        end,
        function (path, flags)
          if path:match('%.zip$') then
            hs.task.new("/usr/bin/open", nil, nil, {path}):start()
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

-- ### plain init configuration

--- returns the short hostname from the output of the `hostname -s` command
---@return string @current hostname
local function hostname()
  local proc = io.popen("/bin/hostname -s")
  local hostname = proc:read("l") or ""
  proc:close()

  return hostname
end

if hostname() == "C02DQ36NMD6P" then
  -- minimize personal browser and other utility applications
  hs.hotkey.bind({"ctrl", "option", "command"}, "m", function()
    local windows = hs.window.filter.new({
      ["Agenda"] = true,
      ["Safari"] = true,
    }):getWindows()
    for _, window in pairs(windows) do
      window:minimize()
    end
  end)

  -- toggle Microsoft Teams mute
  hs.hotkey.bind(nil, "F19", nil, function()
    hs.eventtap.event.newKeyEvent({"cmd", "shift"}, "m", true):post(hs.application.get("com.microsoft.teams"))
  end)

  -- apply all rules on Microsft Outlook
  hs.hotkey.bind(nil, "F18", nil, function()
    local success, output, details = hs.osascript.applescriptFromFile(os.getenv("HOME") .. "/Library/Scripts/MSOutlookApplyAllRules.applescript")
    if success ~= true then logger.e(output, details) end
  end)
end
