require("types.hammerspoon")

local logger = hs.logger.new("work", "error")

hs.spoons.use("WebWidgets", {
  loglevel = "error",
})
---@type WebWidgets
spoon.WebWidgets = spoon.WebWidgets

-- toggle Microsoft Teams mute
hs.hotkey.bind(nil, "F19", nil, function()
  hs.eventtap.event.newKeyEvent({ "cmd", "shift" }, "m", true):post(hs.application.get("com.microsoft.teams"))
end)

-- apply all rules on Microsoft Outlook
hs.hotkey.bind(nil, "F18", nil, function()
  local success, output, details = hs.osascript.applescriptFromFile(os.getenv("HOME") ..
    "/Library/Scripts/MSOutlookApplyAllRules.applescript")
  if success ~= true then logger.e(table.concat(output or {}, "\n"), details) end
end)

local workIntranetHostname = os.getenv("WORK_INTRANET_HOSTNAME")
if workIntranetHostname == nil or workIntranetHostname:len() <= 0 then
  logger.e("work intranet hostname not set - skipping VPN and widget setup")
  return
end

local adoPatID = os.getenv("AZURE_DEVOPS_EXT_PAT_ID")
if adoPatID == nil or adoPatID:len() <= 0 then
  logger.e("Azure DevOps PAT ID not set")
  return
end

---@param id string
---@return boolean
local function updateADOToken(id)
  local _, status = hs.execute(string.format("az dopat update --id %s --days 15", id), true)
  return status == true
end

logger.v("loading widgets...")
local widgets = require("tags.work.widgets")

logger.v("initializing widgets...")
widgets:init()

logger.v("setting up reachability...")
--- @type boolean
local workVpnIsUp = nil
hs.network.reachability.forHostName(workIntranetHostname):setCallback(function(self, flags)
  local isReachable = (flags & hs.network.reachability.flags.reachable) == hs.network.reachability.flags.reachable

  hs.execute([[fish -c 'aab renice']], true)

  if isReachable and workVpnIsUp ~= true then
    -- VPN tunnel is up
    logger.i("VPN is up!")
    -- TODO check if the keychain entry exists
    hs.execute(string.format("kinit --keychain %s@%s", os.getenv("KERBEROS_PRINCIPAL"), os.getenv("KERBEROS_REALM")))
    updateADOToken(adoPatID)
    widgets:start()
    if workVpnIsUp == false then
      hs.urlevent.openURL("hammerspoon://contexts?name=work&action=open")
    end
    workVpnIsUp = true
  elseif not isReachable and workVpnIsUp ~= false then
    -- VPN tunnel is down
    logger.i("VPN is down!")
    hs.execute("kdestroy -A")
    widgets:stop()
    if workVpnIsUp == true then
      hs.urlevent.openURL("hammerspoon://contexts?name=work&action=kill")
    end
    workVpnIsUp = false
  end
end):start()

-- must not be local, otherwise it'll be garbage collected
TimeReloader = hs.timer.doAt("09:00", "1d", function()
  updateADOToken(adoPatID)
end, true):start()

logger.v("loaded successfully")
