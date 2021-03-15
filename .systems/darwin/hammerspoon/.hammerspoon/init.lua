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
