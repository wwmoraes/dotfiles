---@class EventTapEventFlags
---@field cmd boolean
---@field alt boolean
---@field shift boolean
---@field ctrl boolean
---@field fn boolean
local EventTapEventFlags

---@param mods EventTapEventKeyModifierFlag[]
---@return boolean
function EventTapEventFlags:contains(mods)end

---@param mods EventTapEventKeyModifierFlag[]
---@return boolean
function EventTapEventFlags:containExactly(mods)end
