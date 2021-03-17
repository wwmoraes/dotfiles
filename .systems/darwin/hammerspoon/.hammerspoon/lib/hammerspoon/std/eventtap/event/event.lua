---@class EventTapEvent
---@field properties EventTapEventProperties
---@field rawFlagMasks EventTapEventRawFlagMasks
---@field types EventTapEventTypes|table<integer,EventTapEventType>
local EventTapEvent

---@param modifiers EventTapEventModifier[]
---@param character string
---@return EventTapEventInstance[]
function EventTapEvent.newKeyEventSequence(modifiers, character)end

---@return EventTapEventInstance
function EventTapEvent.newEvent()end

---@param data string
---@return EventTapEventInstance
function EventTapEvent.newEventFromData(data)end

---@param gestureType EventTapEventGestureType
---@param gestureValue number|nil
---@return EventTapEventInstance|nil
function EventTapEvent.newGesture(gestureType, gestureValue)end

---@param mods EventTapEventKeyModifier[]|nil
---@param key string|integer
---@param isdown boolean
---@return EventTapEventInstance
function EventTapEvent.newKeyEvent(mods, key, isdown)end

---@param eventtype EventTapEventTypeNameMouse|integer
---@param point EventTapPoint
---@param modifiers EventTapEventKeyModifier|nil
---@return EventTapEventInstance
function EventTapEvent.newMouseEvent(eventtype, point, modifiers)end

---@param offsets EventTapOffsets
---@param mods EventTapEventKeyModifier|nil
---@param unit EventTapScrollWheelUnit
---@return EventTapEventInstance
function EventTapEvent.newScrollEvent(offsets, mods, unit)end

---@param key EventTapEventSpecialKeyName
---@param isdown boolean
---@return EventTapEventInstance
function EventTapEvent.newSystemKeyEvent(key, isdown)end
