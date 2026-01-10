pcall(require, "types.hammerspoon")

require("hs.ipc")

hs.notify.withdrawAll()

local logger = hs.logger.new("init", "info")

hs.application.enableSpotlightForNameSearches(true)

-- named after a disabled feature from hs.host.locale
-- https://github.com/Hammerspoon/hammerspoon/blob/b03d628f792eb88188962643c32a490f1174c10d/extensions/host/locale/libhost_locale.m#L74
if hs.settings.getKeys()["timeZone"] == nil then
	logger.i("storing timezone name...")
	local output = hs.execute([[stat -f '%Y' /etc/localtime | sed -e 's@.*/zoneinfo/@@']])
	output = output:gsub("%c+", "")
	if output:len() > 0 then
		hs.settings.set("timeZone", output)
	end
end
