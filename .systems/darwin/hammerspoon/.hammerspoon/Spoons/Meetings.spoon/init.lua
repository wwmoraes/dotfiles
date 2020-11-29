--- === Meetings ===
---
--- automatically opens the Google Meet link of calendar events
---

--- @class Meetings : Spoon
local obj = {}
obj.__index = obj

-- Metadata
obj.name = "Meetings"
obj.version = "1.0"
obj.author = "William Artero"
obj.license = "MIT - https://opensource.org/licenses/MIT"

--- global logger instance
obj.logger = hs.logger.new(string.lower(obj.name))

--- ICS calendar URL to fetch events from
--- @type string
obj.calendarURL = nil

local utils = require("lib.utils")
local ical = require("lib.ical")

--- stop current timers, and remove them
--- @return Meetings @the Meetings object
function obj:cleanupTimers()
  self.logger.i("stopping and removing timers...")
  while #self.timers > 0 do
    table.remove(self.timers, #self.timers):stop()
  end
  self.logger.i("timers stopped and removed successfully")
  return self
end

--- @return Meetings @the Meetings object
function obj:createTimers()
  assert(self.calendarURL ~= nil, "no calendar URL set")
  return self
end

--- @return Meetings @the Meetings object
function obj:start()
  hs.urlevent.bind(string.lower(self.name), function(eventName, params)
    if params.action == nil then
      self.logger.e("no action provided")
      return
    end

    if params.action == "cleanup" then
      self:cleanupTimers()
      return
    end

    if params.action == "schedule" then
      --cleanup asyncronously
      -- self:cleanupTimers()
      hs.urlevent.openURL(string.format("hammerspoon://%s?action=cleanup", eventName))
      self:createTimers()
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
            local endTime = os.time(utils.endOfDay(now))
            local timeRange = ical.span(startTime, endTime)
            local events = ical.events(cal)
            local newTimers = {}
            for _,v in ipairs(events) do
              if ical.is_in(v, timeRange) then
                local meetURL = v.DESCRIPTION:match('(https://meet%.google%.com/[a-z]+-[a-z]+-[a-z]+)')
                if meetURL ~= nil then
                  local time = os.date("%H:%M", v.DTSTART)
                  local openTime = os.date("%H:%M", v.DTSTART - (5*60))
                  table.insert(newTimers, hs.timer.doAt(openTime, 0, function()
                    hs.urlevent.openURLWithBundle(meetURL, "org.mozilla.firefox")
                  end, true))
                  self.logger.d(string.format("scheduled %s %s (opens on %s)", v.SUMMARY, time, openTime))
                end
              end
            end
            --wait for the cleanup to happen
            repeat
              if self.timers == {} then
                self.timers = newTimers
                break
              end
            until true
            self.logger.i("meeting crons setup successfully")
          else
            hs.alert.show("response error")
          end
        end
      )
    end
  end)
  return self
end

return obj
