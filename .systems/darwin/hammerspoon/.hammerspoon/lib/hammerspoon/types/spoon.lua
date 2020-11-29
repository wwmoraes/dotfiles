-- Spoon definitions

--- @class SpoonMetadata
--- @field public name string the name of the Spoon
--- @field public version string the version of the Spoon
--- @field public author string the Spoon's author name and email
--- @field public license string the license of the spoon
--- @field public homepage string|nil the homepage of the spoon

--- @class Spoon : SpoonMetadata
local Spoon = {}

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
