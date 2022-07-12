local snowURL = assert(os.getenv("SNOW_URL"), "Service Now URL not set")
local onCallGroupID = assert(os.getenv("SNOW_ONCALL_GROUP_ID"), "Service Now on-call group ID not set")
local onCallRotasID = assert(os.getenv("SNOW_ONCALL_ROTAS_ID"), "Service Now on-call rotation ID not set")
local onCallRostersID = assert(os.getenv("SNOW_ONCALL_ROSTERS_ID"), "Service Now on-call rosters ID not set")
local supportGroupID = assert(os.getenv("SNOW_SUPPORT_GROUP_ID"), "Service Now support group ID not set")
local supportRotasID = assert(os.getenv("SNOW_SUPPORT_ROTAS_ID"), "Service Now support rotation ID not set")
local timeZone = hs.settings.get("timeZone") or "Universal"

---@class WorkWidgets
---@field widgets WebWidget[]
local obj = {
  widgets = {},
}

function obj:start()
  for _, widget in ipairs(self.widgets) do
    widget:start()
  end
end

function obj:stop()
  for _, widget in ipairs(self.widgets) do
    widget:stop()
  end
end

table.insert(obj.widgets, spoon.WebWidgets:new({
  rectangle = hs.geometry.rect(24, 52, 300, 486),
  baseURL = snowURL,
  endpoint = "$oc.do",
  exactURL = true,
  refreshOn = {
    events = {
      hs.caffeinate.watcher.systemDidWake,
      hs.caffeinate.watcher.screensDidUnlock,
    },
    times = {
      {
        time = "09:00",
        repeatInterval = "1d",
      }
    }
  },
  params = {
    -- spell-checker: disable
    ["sysparm_include_view"] = "daily,weekly,monthly",
    ["sysparm_timezone"] = timeZone,
    ["sysparm_timeline_enabled"] = "false",
    ["sysparm_current_view"] = "daily",
    ["sysparm_group_id"] = supportGroupID,
    ["sysparm_rotas"] = supportRotasID,
    ["sysparm_show_gaps"] = "false",
    ["sysparm_show_conflicts"] = "false",
    ["sysparm_rosters"] = "",
    -- spell-checker: enable
  },
  -- spell-checker: disable
  style = [[
    /* reposition progress indicator */
    .ing-indicator.icon-loading { top: 11px !important; right: 11px !important; }

    /* remove unneeded controls */
    .calendarHeader .leftContainer,
    .calendarHeader .rightContainer,
    sn-on-call-filter
    { display: none !important; }

    /* fix header after control removal */
    .calendarHeader .middleContainer { margin-top: 0 !important; }
    .dhx_cal_navline { height: 44px !important; margin-bottom: 0; border: 0; }
    .dhx_cal_data { top: 44px !important; overflow: hidden; height: 440px !important; }

    /* reposition calendar view */
    .dhx_scale_holder, .dhx_scale_holder_now { top: -352px !important; } /* each hour = 44px */
  ]]
  -- spell-checker: enable
}))

table.insert(obj.widgets, spoon.WebWidgets:new({
  rectangle = hs.geometry.rect(348, 52, 860, 236),
  baseURL = snowURL,
  endpoint = "$oc.do",
  exactURL = true,
  refreshOn = {
    events = {
      hs.caffeinate.watcher.systemDidWake,
      hs.caffeinate.watcher.screensDidUnlock,
    },
    times = {
      {
        time = "09:00",
        repeatInterval = "1d",
      }
    }
  },
  params = {
    -- spell-checker: disable
    ["sysparm_include_view"] = "daily,weekly,monthly",
    ["sysparm_timezone"] = timeZone,
    ["sysparm_timeline_enabled"] = "true",
    ["sysparm_current_view"] = "weekly",
    ["sysparm_group_id"] = onCallGroupID,
    ["sysparm_rotas"] = onCallRotasID,
    ["sysparm_rosters"] = onCallRostersID,
    ["sysparm_show_gaps"] = "false",
    ["sysparm_show_conflicts"] = "false"
    -- spell-checker: enable
  },
  -- spell-checker: disable
  style = [[
    /* reposition progress indicator */
    .icon-loading { top: 9px !important; left: 9px !important; right: auto !important; }

    /* remove unneeded controls */
    .dhx_cal_navline, sn-on-call-filter { display: none !important; }

    /* fix header after control removal */
    .dhx_cal_header { top: 0px !important; left: -2px !important; }
    .dhx_cal_data { top: 36px !important; overflow: hidden; height: 440px !important; }

    /* hide group rows (roster + time off) */
    .dhx_cal_data .dhx_row_folder { display: none; }

    /* hide time off rows */
    .dhx_cal_data .dhx_row_folder:not(:first-of-type) ~ .dhx_row_item { display: none; }
  ]],
  -- spell-checker: enable
}))

return obj
