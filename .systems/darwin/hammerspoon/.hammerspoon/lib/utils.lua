local obj = {}
obj.__index = obj

obj.name = "Utils"
obj.version = "1.0"
obj.author = "William Artero"
obj.license = "MIT - https://opensource.org/licenses/MIT"

---dump returns a string representation of any object
---@param o any
---@return string
function obj.dump(o)
  if type(o) == 'table' then
     local s = '{ '
     for k,v in pairs(o) do
        if type(k) ~= 'number' then k = '"'..k..'"' end
        s = s .. '['..k..'] = ' .. obj.dump(v) .. ','
     end
     return s .. '} '
  else
     return tostring(o)
  end
end

---@param date table
---@return table
function obj.startOfDay(date)
  return {
    year = date.year,
    month = date.month,
    day = date.day,
    hour = 0,
    min = 0,
    sec = 0,
    wday = date.wday,
    yday = date.yday,
    isdst = date.isdst,
  }
end

---@param date table
---@return table
function obj.endOfDay(date)
  return {
    year = date.year,
    month = date.month,
    day = date.day,
    hour = 23,
    min = 59,
    sec = 59,
    wday = date.wday,
    yday = date.yday,
    isdst = date.isdst,
  }
end

return obj
