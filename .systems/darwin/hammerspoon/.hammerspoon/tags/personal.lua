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

  local output, status, _
  local tries = 3
  for i = 1, tries, 1 do
    output, status, _ = hs.execute("/opt/homebrew/bin/fish -c 'pgpz unlock'")
    if status == true then
      break
    end

    logger.ef("[%d/%d] failed to unlock GPG: %s", i, tries, output)
  end

  if status ~= true then
    logger.ef("failed to unlock GPG, backing off after %d tries", tries)
  end
end):start()
