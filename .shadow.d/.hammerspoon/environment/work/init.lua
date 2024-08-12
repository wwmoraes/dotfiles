pcall(require, "types.hammerspoon")

local logger = hs.logger.new("work", "error")

---@param id string
---@return boolean
local function updateADOToken(id)
  local _, status = hs.execute(string.format("az dopat update --id %s --days 15", id), true)
  return status == true
end

---@param principal string
---@return boolean
local function refreshKerberosPrincipal(principal)
  local _, status = hs.execute("kinit --keychain " .. principal)
  return status == true
end

local function shouldRenewKerberos()
  local output, status = hs.execute([[klist --json | jq -r '.tickets[].Expires']], true)
  if status ~= true then
    return true
  end

  local now = os.time()
  local year, month, day = os.date("%Y-%m-%d", now):match('(%d+)-(%d+)-(%d+)')
  local nowStr = os.date("%Y%m%d%H%M%S", os.time({
    year = year,
    month = month,
    day = day,
    hour = 17,
    min = 0,
    sec = 0,
  }))
  for expDate in output:gmatch("(.-)[\r\n]+") do
    if expDate <= nowStr then
      return true
    end
  end

  return false
end

local function setupVPN()
  local workIntranetHostname = os.getenv("WORK_INTRANET_HOSTNAME")
  if workIntranetHostname == nil or workIntranetHostname:len() <= 0 then
    logger.e("work intranet hostname not set - skipping VPN and widget setup")
    return
  end

  logger.v("setting up reachability...")
  hs.network.reachability.forHostName(workIntranetHostname):setCallback(function(self, flags)
    local isReachable = (flags & hs.network.reachability.flags.reachable) == hs.network.reachability.flags.reachable

    hs.execute([[fish -c 'aab renice']], true)

    if isReachable then
      if shouldRenewKerberos() then
        refreshKerberosPrincipal(string.format("%s@%s", os.getenv("KERBEROS_PRINCIPAL"), os.getenv("KERBEROS_REALM")))
      end
    end
  end):start()
end

local function setupMenu()
  SNG = hs.menubar.new(true)
  SNG:setIcon(hs.image.imageFromPath(table.concat({
    hs.configdir,
    "environment/work",
    "logo.png"
  }, "/")):size({ h = 16, w = 16 }), false)
  SNG:setTooltip("easy AAB")
  SNG:setMenu({
    {
      title = "Open ServiceNow Green item",
      shortcut = "o",
      fn = function()
        local text = hs.pasteboard.readString()
        if text == nil then
          local button, text = hs.dialog.textPrompt("ID", "the item identifier number/code")
          if button ~= "OK" then
            return
          end
        end

        hs.urlevent.openURL("https://servicenow.abnamro.org/text_search_exact_match.do?sysparm_search=" .. text)
      end
    }, {
    title = "-"
  }, {
    title = "TODO",
    disabled = true
  }
  })
end

local function setupPATRenewer()
  local adoPatID = os.getenv("AZURE_DEVOPS_EXT_PAT_ID")
  if adoPatID == nil or adoPatID:len() <= 0 then
    logger.e("Azure DevOps PAT ID not set")
    return
  end

  -- must not be local, otherwise it'll be garbage collected
  TimeReloader = hs.timer.doAt("09:30", "1d", function()
    updateADOToken(adoPatID)
  end, true):start()
end

setupPATRenewer()
setupVPN()
setupMenu()

logger.v("loaded successfully")
