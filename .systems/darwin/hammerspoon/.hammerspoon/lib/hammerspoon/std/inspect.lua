--- function that will be called for each item of an inspection
--- @param item any @current item being processed
--- @param path string @item's position in the variable being inspected
--- @return any @either a processed form of the variable, the original variable itself if it requires no processing, or nil to remove the item from the inspected output
--- @alias InspectProcessFn "function(item:any, path:string):any"

--- @class InspectOptions
--- maximum depth to recurse into variable. Below that depth, data will be displayed as {...}
--- @field depth number
--- line breaks string. Defaults to `\n`
--- @field newline string
--- indentation string. Defaults to `  ` (two spaces)
--- @field indent string
--- function that will be called for each item
--- @field process InspectProcessFn
--- if true, include (and traverse) metatables
--- @field metatables boolean

--- Produce human-readable representations of Lua variables (particularly tables)
--- @class Inspect
local Inspect

-- TODO add annotation for the call form of the table when emmy's implementation starts supporting it

--- Gets a human readable version of the supplied Lua variable
---
--- Notes:
--- * For convenience, you can call this function as `hs.inspect(variable)`
--- * For more information on the options, and some examples, see the upstream docs
---
--- @param variable any @A lua variable of some kind
--- @param options InspectOptions|nil @table with options to influence the inspector
--- @return string @A string containing the human readable version of `variable`
function Inspect.inspect(variable, options)end
