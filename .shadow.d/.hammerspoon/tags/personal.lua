-- pcall(require, "types.hammerspoon")

local logger = hs.logger.new("personal", "verbose")

logger.i("loading personal tag settings")

local linkIPURL = os.getenv("NEXTDNS_LINK_IP_URL")

if linkIPURL == nil or linkIPURL:len() <= 0 then
  logger.w("NEXTDNS_LINK_IP_URL unset or empty, skipping reachability callback")
else
  hs.network.reachability.forAddress("172.24.174.4"):setCallback(function(self, flags)
    if (flags & hs.network.reachability.flags.isLocalAddress) > 0 then
      logger.i("VPN is up!")
      hs.http.get(linkIPURL, nil)
    else
      logger.i("VPN is down!")
    end
  end):start()
end
