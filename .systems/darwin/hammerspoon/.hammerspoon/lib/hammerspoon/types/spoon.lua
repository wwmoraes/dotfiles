-- Spoon definitions

--- @class SpoonMetadata
--- @field public name string @Spoon's name
--- @field public version string @Spoon's version
--- @field public author string @Spoon's author name and email
--- @field public license string @Spoon's license
--- @field public homepage string|nil @Spoon's homepage
--- @field public defaultHotkeys table<string,HotkeyMapping> @Spoon's default hotkey mapping

--- @class Spoon : SpoonMetadata
local Spoon

--- executes any initial work needed by the Spoon
--- @return Spoon @the spoon object
function Spoon:init()end

--- binds hotkeys to bindable Spoon functions
--- @param mapping HotkeyMapping table of strings that describe bindable actions of the spoon, with hotkey spec values
--- @return Spoon @the spoon object
function Spoon:bindHotkeys(mapping)end

--- starts background work/processes needed by the Spoon
--- @return Spoon @the spoon object
function Spoon:start()end

--- stops running background work/processes started by the Spoon
--- @return Spoon @the spoon object
function Spoon:stop()end
