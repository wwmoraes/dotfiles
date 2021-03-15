---@class ApplicationInstance
local ApplicationInstance

---@param allWindows boolean|nil
---@return boolean
function ApplicationInstance:activate(allWindows)end

---@return WindowInstance[]
function ApplicationInstance:allWindows()end

---@return string
function ApplicationInstance:bundleID()end

---@param menuItem string|string[]
---@param isRegex boolean|nil
---@return ApplicationMenuItemState|nil
function ApplicationInstance:findMenuItem(menuItem, isRegex)end

---@param titlePattern string
---@return WindowInstance[]|nil
function ApplicationInstance:findWindow(titlePattern)end

---@return WindowInstance|nil
function ApplicationInstance:focusedWindow()end

---@param fn function|nil
---@return ApplicationMenuItem[]|nil|ApplicationInstance
function ApplicationInstance:getMenuItems(fn)end

---@param title string
---@return WindowInstance|nil
function ApplicationInstance:getWindow(title)end

---@return boolean
function ApplicationInstance:hide()end

---@return boolean
function ApplicationInstance:isFrontmost()end

---@return boolean
function ApplicationInstance:isHidden()end

---@return boolean
function ApplicationInstance:isRunning()end

function ApplicationInstance:kill()end

function ApplicationInstance:kill9()end

---@return number
function ApplicationInstance:kind()end

---@return WindowInstance|nil
function ApplicationInstance:mainWindow()end

---@return string
function ApplicationInstance:name()end

---@return string
function ApplicationInstance:path()end

---@return integer
function ApplicationInstance:pid()end

---@param menuitem string|string[]
---@param isRegex boolean|nil
---@return 'true'|nil
function ApplicationInstance:selectMenuItem(menuitem, isRegex)end

---@param allWindows boolean|nil
---@return boolean
function ApplicationInstance:setFrontmost(allWindows)end

---@return string
function ApplicationInstance:title()end

---@return boolean
function ApplicationInstance:unhide()end

---@return WindowInstance[]
function ApplicationInstance:visibleWindows()end
