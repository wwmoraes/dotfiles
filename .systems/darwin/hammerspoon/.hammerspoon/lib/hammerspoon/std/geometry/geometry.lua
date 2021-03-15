---@class Geometry
local Geometry

---@param geom GeometryInstance
---@return GeometryInstance
function Geometry.copy(geom)end

---@vararg any
---@return GeometryInstance
function Geometry.new(...)end

---@param x integer
---@param y integer
---@return GeometryInstance
function Geometry.point(x, y)end

---@param x integer
---@param y integer
---@param w integer
---@param h integer
---@return GeometryInstance
function Geometry.rect(x, y, w, h)end

---@param w integer
---@param h integer
---@return GeometryInstance
function Geometry.size(w, h)end
