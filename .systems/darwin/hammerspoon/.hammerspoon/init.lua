require("lib.hammerspoon")

hs.spoons.use("ReloadConfiguration", {
  config = {
    watch_paths = {
      hs.configdir,
      os.getenv("HOME") .. "/.files/.systems/darwin/hammerspoon/.hammerspoon"
    },
  },
  start = true,
})

hs.spoons.use("Env", {
  config = {
    ---@type table<string,ContextName>
    contexts = {
      ["M1Cabuk"] = "personal",
      ["NLMBF04E-C82334"] = "work",
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
        applications = {
          "Firefox",
          "Teams",
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
