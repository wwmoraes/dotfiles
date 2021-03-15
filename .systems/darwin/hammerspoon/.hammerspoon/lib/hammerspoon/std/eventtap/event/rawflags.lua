---@class EventTapEventRawFlagMasks
--- Corresponds to the left (or only) alt key on the keyboard
---@field alternate integer
--- Corresponds to the left (or only) cmd key on the keyboard
---@field command integer
--- Corresponds to the left (or only) ctrl key on the keyboard
---@field control integer
--- Corresponds to the left (or only) shift key on the keyboard
---@field shift integer
--- Indicates that the key corresponds to one defined as belonging to the numeric keypad, if present
---@field numericPad integer|nil
--- Indicates the fn key found on most modern Macintosh laptops. May also be observed with function and other special keys (arrows, page-up/down, etc.)
---@field secondaryFn integer
--- Corresponds to the right alt key on the keyboard (if present)
---@field deviceRightAlternate integer|nil
--- Corresponds to the right cmd key on the keyboard (if present)
---@field deviceRightCommand integer|nil
--- Corresponds to the right ctrl key on the keyboard (if present)
---@field deviceRightControl integer|nil
--- Corresponds to the right alt key on the keyboard (if present)
---@field deviceRightShift integer|nil
--- Indicates that multiple mouse movements are not being coalesced into one event if delivery of the event has been delayed
---@field nonCoalesced integer
--- related to the caps-lock in some way?
---@field alphaShift integer
--- related to the caps-lock in some way?
---@field alphaShiftStateless integer
--- related to the caps-lock in some way?
---@field deviceAlphaShiftStateless integer
--- Corresponds to the left alt key on the keyboard (if present)
---@field deviceLeftAlternate integer
--- Corresponds to the left cmd key on the keyboard (if present)
---@field deviceLeftCommand integer
--- Corresponds to the left ctrl key on the keyboard (if present)
---@field deviceLeftControl integer
--- Corresponds to the left shift key on the keyboard (if present)
---@field deviceLeftShift integer
--- related to a modifier found on old NeXT keyboards but not on modern keyboards?
---@field help integer
