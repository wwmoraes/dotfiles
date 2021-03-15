---@alias EventTapKeyboardModifier '"cmd"'|'"⌘"'|'"ctrl"'|'"⌃"'|'"alt"'|'"⌥"'|'"shift"'|'"⇧"'|'"fn"'
---@alias EventTapScrollWheelUnit '"line"'|'"pixel"'

---@param event EventTapEventInstance
---@return boolean|nil,EventTapEventInstance[]
---@alias EventTapCallback "function(event:EventTapEventInstance):boolean|nil,EventTapEventInstance[]|nil"
