---@class EventTap
---@field event EventTapEvent
local EventTap

---@param raw boolean|nil
---@return EventTapKeyboardModifiers
function EventTap.checkKeyboardModifiers(raw)end

---@return table
function EventTap.checkMouseButtons()end

---@return number
function EventTap.doubleClickInterval()end

---@return boolean
function EventTap.isSecureInputEnabled()end

---@return number
function EventTap.keyRepeatDelay()end

---@return number
function EventTap.keyRepeatInterval()end

---@param modifiers EventTapKeyboardModifier[]
---@param character string
---@param delay number|nil
---@param application ApplicationInstance|nil
function EventTap.keyStroke(modifiers, character, delay, application)end

---@param text string
---@param application ApplicationInstance|nil
function EventTap.keyStrokes(text, application)end

---@param point EventTapPoint
---@param delay number|nil
function EventTap.leftClick(point, delay)end

---@param point EventTapPoint
---@param delay number|nil
function EventTap.middleClick(point, delay)end

---@param point EventTapPoint
---@param delay number|nil
---@param button number|nil
function EventTap.otherClick(point, delay, button)end

---@param point EventTapPoint
---@param delay number|nil
function EventTap.rightClick(point, delay)end

---@param offsets EventTapOffsets
---@param modifiers EventTapKeyboardModifier[]|nil
---@param unit EventTapScrollWheelUnit|nil
function EventTap.scrollWheel(offsets, modifiers, unit)end

---@param types EventTapEventType|'"all"'[]
---@param fn EventTapCallback
---@return EventTapInstance
function EventTap.new(types, fn)end
