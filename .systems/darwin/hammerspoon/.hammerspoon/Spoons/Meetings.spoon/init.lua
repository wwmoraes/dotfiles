--- === Meetings ===
---
--- automatically opens the Google Meet link of calendar events 5 minutes before
--- the meeting start time.
---
--- The calendar events are scheduled each day at midnight (can be configured),
--- and relies on a fetchable calendar ics file to get all events from
---

--- @class Meetings : Spoon
--- global logger instance
--- @field protected logger LoggerInstance
--- list of timers created to open the meet links before the start time
--- @field protected timers TimerInstance[]
--- calendar ics file URL to fetch and process the meetings from
--- @field public calendarURL string
--- seconds before the meeting start time to open the meet link
--- (defaults to 5min)
--- @field public secondsBefore number
--- browser bundle to use to open the link (uses the OS default if not set)
--- @field public browserBundleID string
--- the time of the day to run the scheduler and create the timers for all
--- meetings (format: "HH:MM")
--- @field public dailyScheduleTime string
--- Meetings Spoon object
local obj = {
  timers = {},
  calendarURL = nil,
  secondsBefore = 5*60,
  browserBundleID = hs.urlevent.getDefaultHandler("https"),
  dailyScheduleTime = "00:00",
}
obj.__index = obj

-- Metadata
obj.name = "Meetings"
obj.version = "1.0"
obj.author = "William Artero"
obj.license = "MIT - https://opensource.org/licenses/MIT"

--- @type HotkeyMapping
obj.defaultHotkeys = {
  schedule = {{"ctrl", "option", "cmd"}, "m"}
}

--- global logger instance
obj.logger = hs.logger.new(string.lower(obj.name))

local ical = dofile(hs.spoons.resourcePath("ical.lua"))

---@param date table
---@return table
local function endOfDay(date)
  return {
    year = date.year,
    month = date.month,
    day = date.day,
    hour = 23,
    min = 59,
    sec = 59,
    wday = date.wday,
    yday = date.yday,
    isdst = date.isdst,
  }
end

--- stop current timers, and remove them
--- @return Meetings @the Meetings object
function obj:cleanup()
  self.logger.i("stopping and removing timers...")
  while #self.timers > 0 do
    table.remove(self.timers, #self.timers):stop()
  end
  self.logger.i("timers stopped and removed successfully")
  return self
end

--- fetch the ical data and create timers for the meetings
--- @return Meetings @the Meetings object
function obj:schedule()
  assert(self.calendarURL, "no calendar URL set")
  self:cleanup()
  --get the ical and parse it
  hs.http.asyncGet(
    self.calendarURL,
    nil,
    function(httpCode, body)
      if httpCode == 200 then
        local cal, err = ical.new(body)
        if err ~= nil then
          self.logger.ef("ERROR: %s", err)
          return
        end
        local now = os.date("*t")
        local startTime = os.time(now)
        local endTime = os.time(endOfDay(now))
        local timeRange = ical.span(startTime, endTime)
        local events = ical.events(cal)
        for _,v in ipairs(events) do
          if ical.is_in(v, timeRange) then
            local meetURL = v.DESCRIPTION:match('(https://meet%.google%.com/[a-z]+-[a-z]+-[a-z]+)')
            if meetURL ~= nil then
              local time = os.date("%H:%M", v.DTSTART)
              local openTime = os.date("%H:%M", v.DTSTART - self.secondsBefore)
              table.insert(self.timers, hs.timer.doAt(openTime, 0, function()
                hs.urlevent.openURLWithBundle(meetURL, self.browserBundleID)
              end, true))
              self.logger.d(string.format("scheduled %s %s (opens on %s)", v.SUMMARY, time, openTime))
            end
          end
        end
        self.logger.i("meeting crons setup successfully")
      else
        self.logger.e("response error")
      end
    end
  )
  return self
end

--- callback to process URL events from hs.urlevent
--- @param eventName string
--- @param params table
--- @return Meetings @the Meetings object
function obj:handleURLEvent(eventName, params)
  assert(eventName == string.lower(self.name), string.format("unknown event %s", eventName))
  assert(params, "no params provided")
  local actionName = assert(params.action, "no action provided")
  assert(self[actionName], string.format("action %s is not supported", actionName))
  assert(type(self[actionName]) == "function", string.format("invalid action %s", actionName))

  -- execute the action
  self[actionName](self)

  return self
end

--- @param mapping HotkeyMapping table of strings that describe bindable actions of the spoon, with hotkey spec values
--- @return Meetings @the Meetings object
function obj:bindHotkeys(mapping)
  local def = {
    schedule = hs.fnutils.partial(
      hs.urlevent.openURL, "hammerspoon://meetings?action=schedule"
    ),
  }
  hs.spoons.bindHotkeysToSpec(def, mapping)
  return self
end

--- @return Meetings @the Meetings object
function obj:start()
  local eventName = string.lower(self.name)
  local baseURL = "hammerspoon://"..eventName

  hs.urlevent.bind(eventName, function(...)
    local status, err = pcall(self.handleURLEvent, self, ...)
    if not status then self.logger.e(err) end
  end)

  hs.timer.doAt(self.dailyScheduleTime, "1d", function()
    hs.urlevent.openURL(baseURL .. "?action=schedule")
  end)

  return self
end

--- @return Meetings @the Meetings object
function obj:stop()
  hs.urlevent.bind(string.lower(self.name), nil)

  while #self.timers > 0 do
    table.remove(self.timers, #self.timers):stop()
  end

  return self
end

return obj
