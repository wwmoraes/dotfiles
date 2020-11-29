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
    calendarURL = os.getenv("MEETINGS_CALENDAR_URL")
  },
  start = true,
})
--- @type Meetings
spoon.Meetings = spoon.Meetings

-- local Slack = require("Slack")
-- local slackInstance = Slack.new(os.getenv("SLACK_TOKEN"))

hs.timer.doAt("00:00", "1d", function()
  hs.urlevent.openURL("hammerspoon://meetings?action=schedule")
end)

hs.timer.doAt("09:00", "1d", function()
  local except = {
    [1] = true,
    [7] = true
  }

  if except[os.date("*t").wday] then
    return
  end

  hs.urlevent.openURL("hammerspoon://context?name=work&action=open")
  -- slackInstance:usersSetPresence('auto')
end, true)

hs.timer.doAt("17:00", "1d", function()
  local except = {
    [1] = true,
    [7] = true
  }

  if except[os.date("*t").wday] then
    return
  end

  hs.urlevent.openURL("hammerspoon://context?name=work&action=close")
  -- slackInstance:usersSetPresence('away')
end, true)

hs.hotkey.bind({"ctrl", "option", "cmd"}, "m", function()
  hs.urlevent.openURL("hammerspoon://meetings?action=schedule")
end)
