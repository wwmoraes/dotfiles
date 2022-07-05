local logger = hs.logger.new("snow-sup", "error")
local urls = require("helpers.urls")

local snowURL = assert(os.getenv("SNOW_URL"), "Service Now URL not set")
local groupID = assert(os.getenv("SNOW_SUPPORT_GROUP_ID"), "Service Now support group ID not set")
local rotasID = assert(os.getenv("SNOW_SUPPORT_ROTAS_ID"), "Service Now support rotation ID not set")
local timeZone = hs.settings.get("timeZone") or "Universal"

logger.i("building URL...")
local url = urls.build(snowURL, "$oc.do", {
  ["sysparm_include_view"] = "daily,weekly,monthly",
  ["sysparm_timezone"] = timeZone,
  ["sysparm_timeline_enabled"] = "false",
  ["sysparm_current_view"] = "daily",
  ["sysparm_group_id"] = groupID,
  ["sysparm_rotas"] = rotasID,
  ["sysparm_show_gaps"] = "false",
  ["sysparm_show_conflicts"] = "false",
  ["sysparm_rosters"] = "",
})

logger.i("creating WebView instance...")
local webView = hs.webview.new(hs.geometry.rect(24, 52, 300, 486)):sendToBack()
webView:behavior(hs.drawing.windowBehaviors.canJoinAllSpaces)

logger.i("configuring navigation callback...")
webView:navigationCallback(function(action, view)
  if action ~= "didFinishNavigation" then return end

  view:evaluateJavaScript([[
    const stylesElem = document.createElement("style");
    stylesElem.type = "text/css";
    stylesElem.innerText = `
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
    `.trim();
    document.head.appendChild(stylesElem);
    true;
  ]], function(result, error)
    if result ~= nil then logger.i("JS result:", result) end
    if error ~= nil and error.code ~= 0 then
      logger.e("JS error:", hs.inspect(error))
    end
  end)

  view:show()
end)

logger.i("loading URL...")
webView:url(url)

return webView
