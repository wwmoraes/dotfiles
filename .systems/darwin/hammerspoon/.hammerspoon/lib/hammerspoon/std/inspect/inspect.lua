--- Produce human-readable representations of Lua variables (particularly tables)
---@class Inspect
local Inspect

-- TODO add annotation for the call form of the table when emmy's implementation starts supporting it

--- Gets a human readable version of the supplied Lua variable
---
--- Notes:
--- * For convenience, you can call this function as `hs.inspect(variable)`
--- * For more information on the options, and some examples, see the upstream docs
---
---@param variable any @A lua variable of some kind
---@param options InspectOptions|nil @table with options to influence the inspector
---@return string @A string containing the human readable version of `variable`
function Inspect.inspect(variable, options)end
