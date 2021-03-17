---@class EventTapEventInstance
local EventTapEventInstance

---@return EventTapEventInstance
function EventTapEventInstance:copy()end

---@return string
function EventTapEventInstance:asData()end

---@param button integer
---@return boolean
function EventTapEventInstance:getButtonState(button)end

---@param clean boolean|nil
---@return string|nil
function EventTapEventInstance:getCharacters(clean)end

---@return EventTapEventFlags
function EventTapEventInstance:getFlags()end

---@return integer
function EventTapEventInstance:getKeyCode()end

---@param prop number
---@return integer
function EventTapEventInstance:getProperty(prop)end

function EventTapEventInstance:getRawEventData()end

function EventTapEventInstance:getTouchDetails()end

function EventTapEventInstance:getTouches()end

function EventTapEventInstance:getType()end

function EventTapEventInstance:getUnicodeString()end

function EventTapEventInstance:location()end

---@param app ApplicationInstance|nil
---@return EventTapEventInstance
function EventTapEventInstance:post(app)end

function EventTapEventInstance:rawFlags()end

function EventTapEventInstance:setFlags()end

function EventTapEventInstance:setKeyCode()end

function EventTapEventInstance:setProperty()end

function EventTapEventInstance:setType()end

function EventTapEventInstance:setUnicodeString()end

function EventTapEventInstance:systemKey()end

function EventTapEventInstance:timestamp()end
