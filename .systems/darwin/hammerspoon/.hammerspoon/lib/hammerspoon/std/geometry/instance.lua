---@class GeometryInstance
---@field area integer
---@field aspect number
---@field bottomright GeometryInstance|nil
---@field center GeometryInstance
---@field h integer|nil
---@field length number
---@field string string
---@field table GeometryTable
---@field topleft GeometryInstance|nil
---@field w integer|nil
---@field wh GeometryInstance|nil
---@field x integer|nil
---@field x1 integer|nil
---@field x2 integer|nil
---@field x2y2 GeometryInstance|nil
---@field xy GeometryInstance|nil
---@field y integer|nil
---@field y1 integer|nil
---@field y2 integer|nil
local GeometryInstance

---@return number
function GeometryInstance:angle()end

---@param point GeometryInstance
---@return number
function GeometryInstance:angleTo(point)end

---@param point GeometryInstance
---@return number
function GeometryInstance:distance(point)end

---@param other GeometryInstance
---@return boolean
function GeometryInstance:equals(other)end

---@param bounds GeometryParam
---@return GeometryInstance
function GeometryInstance:fit(bounds)end

---@return GeometryInstance
function GeometryInstance:floor()end

---@param frame GeometryParam
---@return GeometryInstance
function GeometryInstance:fromUnitRect(frame)end

---@param rect GeometryInstance
---@return boolean
function GeometryInstance:inside(rect)end

function GeometryInstance:intersect()end

function GeometryInstance:move()end

function GeometryInstance:normalize()end

function GeometryInstance:rotateCCW()end

function GeometryInstance:scale()end

function GeometryInstance:toUnitRect()end

function GeometryInstance:type()end

function GeometryInstance:union()end

---@param point GeometryInstance
---@return GeometryInstance
function GeometryInstance:vector(point)end
