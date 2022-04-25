require("types.hammerspoon")

local logger = hs.logger.new("work", "info")

--- changes the tinyproxy config file link and sends a USR1 signal to the daemon
--- to reload the config
--- @param name string|nil
--- @return nil
local function changeProxyProfile(name)
  name = (name == nil and "direct") or name
  local sourceFile = string.format("%s/.config/tinyproxy/tinyproxy-%s.conf", os.getenv("HOME"), name)
  local targetFile = os.getenv("HOME") .. "/.config/tinyproxy/tinyproxy.conf"
  logger.i("linking proxy profile config file...")
  local output, status, type, rc = hs.execute(string.format("ln -sf '%s' '%s'", sourceFile, targetFile))
  if status ~= true then
    logger.e("failed to link proxy config: %s (%s %d)", output, type, rc)
  end
  -- TODO use the pid file and the standard kill
  logger.i("reloading proxy config...")
  local output, status, type, rc = hs.execute("killall -USR1 tinyproxy")
  if status ~= true then
    logger.e("failed to reload proxy config: %s (%s %d)", output, type, rc)
  end
end

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
    changeProxyProfile("aab-vpn")
    -- TODO check if the keychain entry exists
    hs.execute(string.format("kinit --keychain %s@%s", os.getenv("KERBEROS_PRINCIPAL"), os.getenv("KERBEROS_REALM")))
    if workVpnIsUp == false then
      hs.urlevent.openURL("hammerspoon://contexts?name=work&action=open")
    end
    workVpnIsUp = true
  elseif not isReachable and workVpnIsUp ~= false then
    -- VPN tunnel is down
    logger.i("VPN is down!")
    changeProxyProfile("direct")
    hs.execute("kdestroy -A")
    if workVpnIsUp == true then
      hs.urlevent.openURL("hammerspoon://contexts?name=work&action=kill")
    end
    workVpnIsUp = false
  end
end):start()
