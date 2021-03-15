---@class Spoon : SpoonMetadata
local Spoon

--- executes any initial work needed by the Spoon
---
---@return Spoon @the spoon object
function Spoon:init()end

--- binds hotkeys to bindable Spoon functions
---
---@param mapping HotkeyMapping table of strings that describe bindable actions of the spoon, with hotkey spec values
---@return Spoon @the spoon object
function Spoon:bindHotkeys(mapping)end

--- starts background work/processes needed by the Spoon
---
---@return Spoon @the spoon object
function Spoon:start()end

--- stops running background work/processes started by the Spoon
---
---@return Spoon @the spoon object
function Spoon:stop()end
