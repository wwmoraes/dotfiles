require("types.hammerspoon")

local logger = hs.logger.new("init", "info")

---### third-party spoons configuration

hs.loadSpoon("SpoonInstall")
---@type SpoonInstall
spoon.SpoonInstall = spoon.SpoonInstall
spoon.SpoonInstall.repos.wwmoraes = {
  url = "https://github.com/wwmoraes/spoons",
  desc = "wwmoraes' spoons",
  branch = "release",
}

spoon.SpoonInstall:andUse("ReloadConfiguration", {
  config = {
    watch_paths = {
      hs.configdir,
      os.getenv("HOME") .. "/.files/.systems/darwin/hammerspoon/.hammerspoon"
    },
  },
  start = true,
})

---### development spoons configuration

hs.spoons.use("Env", {
  start = true,
})
---@type Env
spoon.Env = spoon.Env

local apps = {
  msEdge = "Microsoft Edge",
  msTeams = "Microsoft Teams",
  msOutlook = "Microsoft Outlook",
  oneDrive = "OneDrive",
  amethyst = "com.amethyst.Amethyst",
  vscode = "com.microsoft.vscode",
  kitty = "net.kovidgoyal.kitty",
  fluidADO = "Azure DevOps",
}

hs.spoons.use("Contexts", {
  ---@type ContextsConfig
  config = {
    contexts = {
      work = {
        title = "Work",
        openAt = "09:00",
        closeAt = "17:00",
        hostnames = {
          ["M1Cabuk"] = false,
        },
        exceptDays = {
          [1] = true,
          [7] = true
        },
        applications = {
          apps.msEdge,
          apps.msTeams,
          apps.msOutlook,
          apps.oneDrive,
          apps.fluidADO,
        },
      },
      development = {
        title = "Development",
        applications = {
          apps.vscode,
          apps.kitty,
        }
      },
    },
    onWake = {
      open = {
        apps.amethyst
      },
    },
    onSleep = {
      kill = {
        apps.amethyst
      },
    },
  },
  hotkeys = "default",
  start = true,
})
---@type Contexts
spoon.Contexts = spoon.Contexts

hs.spoons.use("Meetings", {
  config = {
    calendarURL = os.getenv("MEETINGS_CALENDAR_URL") or "",
    dailyScheduleTime = "09:00",
    browserBundleID = "org.mozilla.firefox",
  },
  hotkeys = "default",
  start = true,
})
---@type Meetings
spoon.Meetings = spoon.Meetings

hs.spoons.use("Hazel", {
  config = {
    rulesets = {
      [os.getenv("HOME") .. "/Downloads/aws-credentials"] = {
        function(path, flags) return flags.itemCreated end,
        function(path, flags) return flags.itemIsFile end,
        function(path, flags)
          local f = io.open(path, "r")
          return f ~= nil and io.close(f)
        end,
        ---@param path string
        ---@param flags PathwatcherFlags
        function(path, flags)
          local status, err = os.rename(path, os.getenv("HOME") .. "/.aws/credentials")
          if status then return true end
          logger.e(err)
          return false
        end,
      },
      [os.getenv("HOME") .. "/Downloads"] = {
        function(path, flags)
          return path:match(".*/.TheUnarchiverTemp0") and flags.itemIsDir == true
        end,
        function(path, flags)
          return path:match(".*/.TheUnarchiverTemp0/.*")
        end,
        function(path, flags)
          return flags.itemModified or flags.itemRemoved
        end,
        function(path, flags)
          if path:match('%.zip$') then
            hs.task.new("/usr/bin/open", nil, nil, { path }):start()
            return true
          end
          return false
        end
      },
    },
  },
  start = true,
})
---@type Hazel
spoon.Hazel = spoon.Hazel

-- ### plain init configuration

--- reads the tags from the current host tagsrc file
--- @return table<string,boolean>
local function getTags()
  local tagsrc = os.getenv("TAGSRC") or os.getenv("HOME") .. "/.tagsrc"
  local tags = {}
  local fd, err = io.open(tagsrc)
  if err ~= nil then
    return tags
  end

  for tag in fd:lines() do
    tags[tag] = true
  end
  fd:close()

  return tags
end

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

local tags = getTags()
if tags["work"] == true then
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
      if workVpnIsUp ~= nil then
        hs.urlevent.openURL("hammerspoon://contexts?name=work&action=open")
      end
      workVpnIsUp = true
    elseif not isReachable and workVpnIsUp ~= false then
      -- VPN tunnel is down
      logger.i("VPN is down!")
      changeProxyProfile("direct")
      hs.execute("kdestroy -A")
      if workVpnIsUp ~= nil then
        hs.urlevent.openURL("hammerspoon://contexts?name=work&action=kill")
      end
      workVpnIsUp = false
    end
  end):start()
end
