local logger = hs.logger.new("snow-onc", "error")
local urls = require("helpers.urls")

local snowURL = assert(os.getenv("SNOW_URL"), "Service Now URL not set")
local groupID = assert(os.getenv("SNOW_ONCALL_GROUP_ID"), "Service Now on-call group ID not set")
local rotasID = assert(os.getenv("SNOW_ONCALL_ROTAS_ID"), "Service Now on-call rotation ID not set")
local rostersID = assert(os.getenv("SNOW_ONCALL_ROSTERS_ID"), "Service Now on-call rosters ID not set")
local timeZone = hs.settings.get("timeZone") or "Universal"

logger.i("building URL...")
local url = urls.build(snowURL, "$oc.do", {
  ["sysparm_include_view"] = "daily,weekly,monthly",
  ["sysparm_timezone"] = timeZone,
  ["sysparm_timeline_enabled"] = "true",
  ["sysparm_current_view"] = "weekly",
  ["sysparm_group_id"] = groupID,
  ["sysparm_rotas"] = rotasID,
  ["sysparm_rosters"] = rostersID,
  ["sysparm_show_gaps"] = "false",
  ["sysparm_show_conflicts"] = "false"
})

logger.i("creating WebView instance...")
local webView = hs.webview.new(hs.geometry.rect(348, 52, 860, 236)):sendToBack()
webView:behavior(hs.drawing.windowBehaviors.canJoinAllSpaces)

logger.i("configuring navigation callback...")
webView:navigationCallback(function(action, view)
  if action ~= "didFinishNavigation" then return end

  view:evaluateJavaScript([[
    const stylesElem = document.createElement("style");
    stylesElem.type = "text/css";
    stylesElem.innerText = `
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
