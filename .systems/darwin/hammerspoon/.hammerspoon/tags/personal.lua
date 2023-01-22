require("types.hammerspoon")

local logger = hs.logger.new("personal", "info")

GpgLockWatcher = hs.caffeinate.watcher.new(function(eventType)
  if eventType ~= hs.caffeinate.watcher.screensDidLock then
    return
  end

  local output, status, _ = hs.execute("/opt/homebrew/bin/gpg-connect-agent reloadagent /bye")
  if status ~= true then
    logger.ef("failed to lock GPG: %s", output)
  end
end):start()

GpgUnlockWatcher = hs.caffeinate.watcher.new(function(eventType)
  if eventType ~= hs.caffeinate.watcher.screensDidUnlock then
    return
  end

  local output, status, _ = hs.execute("/opt/homebrew/bin/fish -c 'pgpz unlock'")
  if status ~= true then
    logger.ef("failed to lock GPG: %s", output)
  end
end):start()
