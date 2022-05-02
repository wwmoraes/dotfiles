require("types.hammerspoon")

local logger = hs.logger.new("work", "info")

-- toggle Microsoft Teams mute
hs.hotkey.bind(nil, "F19", nil, function()
  hs.eventtap.event.newKeyEvent({ "cmd", "shift" }, "m", true):post(hs.application.get("com.microsoft.teams"))
end)

-- apply all rules on Microsft Outlook
hs.hotkey.bind(nil, "F18", nil, function()
  local success, output, details = hs.osascript.applescriptFromFile(os.getenv("HOME") .. "/Library/Scripts/MSOutlookApplyAllRules.applescript")
  if success ~= true then logger.e(output, details) end
end)

--- @type boolean
local workVpnIsUp = nil

hs.network.reachability.forHostName(os.getenv("WORK_INTRANET_HOSTNAME")):setCallback(function(self, flags)
  local isReachable = (flags & hs.network.reachability.flags.reachable) == hs.network.reachability.flags.reachable

  if isReachable and workVpnIsUp ~= true then
    -- VPN tunnel is up
    logger.i("VPN is up!")
    -- TODO check if the keychain entry exists
    hs.execute(string.format("kinit --keychain %s@%s", os.getenv("KERBEROS_PRINCIPAL"), os.getenv("KERBEROS_REALM")))
    if workVpnIsUp == false then
      hs.urlevent.openURL("hammerspoon://contexts?name=work&action=open")
    end
    workVpnIsUp = true
  elseif not isReachable and workVpnIsUp ~= false then
    -- VPN tunnel is down
    logger.i("VPN is down!")
    hs.execute("kdestroy -A")
    if workVpnIsUp == true then
      hs.urlevent.openURL("hammerspoon://contexts?name=work&action=kill")
    end
    workVpnIsUp = false
  end
end):start()
