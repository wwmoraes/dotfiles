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

hs.spoons.use("Contexts", { hotkeys = "default", start = true })
--- @type Contexts
spoon.Contexts = spoon.Contexts

hs.spoons.use("Meetings", {
  config = {
    calendarURL = os.getenv("MEETINGS_CALENDAR_URL"),
    browserBundleID = "org.mozilla.firefox",
  },
  hotkeys = "default",
  start = true,
})
--- @type Meetings
spoon.Meetings = spoon.Meetings
