--- === Slack ===
---
--- Slack API wrapper
---

local obj = {}
obj.__index = obj

-- Metadata
obj.name = "Slack"
obj.version = "1.0"
obj.author = "William Artero"
obj.license = "MIT - https://opensource.org/licenses/MIT"

---Slack wraps the API with ease-to-use methods
---@class Slack
---@field protected token string
---@field protected logger any
---@field protected expiration_to_seconds table
local Slack = {
  token = "",
  logger = hs.logger.new("Slack"),
  expiration_to_seconds = {
    ["N"] = 0,
    ["30M"] = 1800,
    ["45M"] = 2700,
    ["1H"] = 3600,
  },
}

--- set the user presence status
--- @param status "'auto'"|"'away'"
function Slack:setPresence(status)
  assert(status, "no status provided")

  self:rawAsyncPost({
    presence = status
  }, "users.setPresence")
end

--- sets the user status text and emoji.
--- If no expiration is given, the status will be set indefinitely
--- @param text string
--- @param emoji string
--- @param expiration "'N'"|"'30M'"|"'45M'"|"'1H'"
function Slack:setStatus(text, emoji, expiration)
  assert(text, "no text provided")
  assert(emoji, "no emoji provided")
  local status_expiration = expiration or "N"

  self:rawAsyncPost({
    profile = {
      status_text = text,
      status_emoji = emoji,
      status_expiration = status_expiration
    }
  }, "users.profile.set")
end

--- executes a post call to the slack API with the needed headers and serialized
--- data, and calls the provided callback function with the response
--- @param data table
--- @param endpoint string
--- @param callback fun(httpCode:number, body:string, res:table):nil
function Slack:rawAsyncPost(data, endpoint, callback)
  local data = hs.json.encode(data)
  local headers = {
    ["Authorization"] = "Bearer " .. self.token,
    ["Content-type"] = "application/json; charset=utf-8"
  }
  hs.http.asyncPost(
    "https://slack.com/api/"..endpoint,
    data,
    headers,
    function(httpCode, body)
      local res = hs.json.decode(body)

      self.logger.df("Slack API response body: \n%s", body)

      if httpCode == 200 then
        if not res.ok then
          hs.notify.new({title = "Slack API call failed!", informativeText = res.error}):send()
          self.logger.df("Slack API response error: %s", res.error)
          return false
        else
          if type(callback) == "function" then
            callback(httpCode, body, res)
          end
        end
      else
          hs.notify.new({title = "Slack API call failed!", informativeText = res.error}):send()
          self.logger.df("Slack API response error: %s", res.error)
          return false
      end
    end
  )
end

--- creates a new instance of Slack with the provided token
--- @param token string
--- @return Slack
function obj.new(token)
  assert(token, "a token must be provided")
  -- TODO assert token format

  local instance = {
    token = token,
    logger = obj.logger
  }
  setmetatable(instance, Slack)
  Slack.__index = Slack

  return instance
end

return obj
