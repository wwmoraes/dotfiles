---@class Window
---@field filter WindowFilter
---@field highlight WindowHighlight
---@field layout WindowLayout
---@field switcher WindowSwitcher
---@field tiling WindowTiling
---@field animationDuration number
---@field setFrameCorrectness boolean
local Window

---@return WindowInstance[]
function Window.allWindows()end

---@return WindowInstance
function Window.desktop()end

---@return WindowInstance[]
function Window.invisibleWindows()end

---@param allWindows boolean|nil
---@return CGWindow[]
function Window.list(allWindows)end

---@return WindowInstance[]
function Window.minimizedWindows()end

---@return WindowInstance[]
function Window.orderedWindows()end

---@param shadows boolean
function Window.setShadows(shadows)end

---@param ID integer
---@param keepTransparency boolean|nil
---@return ImageInstance|nil
function Window.snapshotForID(ID, keepTransparency)end

---@param value integer
---@return boolean
function Window.timeout(value)end

---@return WindowInstance[]
function Window.visibleWindows()end

---@param hint integer|string
---@return WindowInstance|WindowInstance[]|nil
function Window.find(hint)end

---@return WindowInstance
function Window.focusedWindow()end

---@return WindowInstance|nil
function Window.frontmostWindow()end

---@param hint integer|string
---@return WindowInstance|nil
function Window.get(hint)end
