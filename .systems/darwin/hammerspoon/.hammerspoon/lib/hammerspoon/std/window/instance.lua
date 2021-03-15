---@class WindowInstance
local WindowInstance

---@return ApplicationInstance|nil
function WindowInstance:application()end

---@return WindowInstance
function WindowInstance:becomeMain()end

---@param screen ScreenInstance|nil
---@param ensureIsInScreenBounds boolean|nil
---@param duration integer|nil
---@return WindowInstance
function WindowInstance:centerOnScreen(screen, ensureIsInScreenBounds, duration)end

---@return boolean
function WindowInstance:close()end

---@return WindowInstance
function WindowInstance:focus()end

---@param index integer
---@return boolean
function WindowInstance:focusTab(index)end

---@param candidateWindows WindowInstance[]|nil
---@param frontmost boolean|nil
---@param strict boolean|nil
---@return boolean
function WindowInstance:focusWindowEast(candidateWindows, frontmost, strict)end

---@param candidateWindows WindowInstance[]|nil
---@param frontmost boolean|nil
---@param strict boolean|nil
---@return boolean
function WindowInstance:focusWindowNorth(candidateWindows, frontmost, strict)end

---@param candidateWindows WindowInstance[]|nil
---@param frontmost boolean|nil
---@param strict boolean|nil
---@return boolean
function WindowInstance:focusWindowSouth(candidateWindows, frontmost, strict)end

---@param candidateWindows WindowInstance[]|nil
---@param frontmost boolean|nil
---@param strict boolean|nil
---@return boolean
function WindowInstance:focusWindowWest(candidateWindows, frontmost, strict)end

---@return GeometryInstance
function WindowInstance:frame()end

---@return integer|nil
function WindowInstance:id()end

---@return boolean|nil
function WindowInstance:isFullScreen()end

---@return boolean|nil
function WindowInstance:isMaximizable()end

---@return boolean
function WindowInstance:isMinimized()end

---@return boolean
function WindowInstance:isStandard()end

---@return boolean
function WindowInstance:isVisible()end

---@param duration integer|nil
---@return WindowInstance
function WindowInstance:maximize(duration)end

---@return WindowInstance
function WindowInstance:minimize()end

---@param rect GeometryInstance
---@param screen ScreenInstance|nil
---@param ensureIsInScreenBounds boolean|nil
---@param duration integer|nil
---@return WindowInstance
function WindowInstance:move(rect, screen, ensureIsInScreenBounds, duration)end

---@param noResize boolean|nil
---@param ensureIsInScreenBounds boolean|nil
---@param duration integer|nil
---@return WindowInstance
function WindowInstance:moveOneScreenEast(noResize, ensureIsInScreenBounds, duration)end

---@param noResize boolean|nil
---@param ensureIsInScreenBounds boolean|nil
---@param duration integer|nil
---@return WindowInstance
function WindowInstance:moveOneScreenNorth(noResize, ensureIsInScreenBounds, duration)end

---@param noResize boolean|nil
---@param ensureIsInScreenBounds boolean|nil
---@param duration integer|nil
---@return WindowInstance
function WindowInstance:moveOneScreenSouth(noResize, ensureIsInScreenBounds, duration)end

---@param noResize boolean|nil
---@param ensureIsInScreenBounds boolean|nil
---@param duration integer|nil
---@return WindowInstance
function WindowInstance:moveOneScreenWest(noResize, ensureIsInScreenBounds, duration)end

---@param screen ScreenInstance
---@param noResize boolean|nil
---@param ensureIsInScreenBounds boolean|nil
---@param duration integer|nil
---@return WindowInstance
function WindowInstance:moveToScreen(screen, noResize, ensureIsInScreenBounds, duration)end

---@param unitrect GeometryInstance
---@param duration integer|nil
---@return WindowInstance
function WindowInstance:moveToUnit(unitrect, duration)end

function WindowInstance:otherWindowsAllScreens()end

function WindowInstance:otherWindowsSameScreen()end

function WindowInstance:raise()end

function WindowInstance:role()end

function WindowInstance:screen()end

function WindowInstance:sendToBack()end

function WindowInstance:setFrame()end

function WindowInstance:setFrameInScreenBounds()end

function WindowInstance:setFrameWithWorkarounds()end

function WindowInstance:setFullScreen()end

function WindowInstance:setSize()end

function WindowInstance:setTopLeft()end

function WindowInstance:size()end

function WindowInstance:snapshot()end

function WindowInstance:subrole()end

function WindowInstance:tabCount()end

function WindowInstance:title()end

function WindowInstance:toggleFullScreen()end

function WindowInstance:toggleZoom()end

function WindowInstance:topLeft()end

function WindowInstance:unminimize()end

function WindowInstance:windowsToEast()end

function WindowInstance:windowsToNorth()end

function WindowInstance:windowsToSouth()end

function WindowInstance:windowsToWest()end

function WindowInstance:zoomButtonRect()end
