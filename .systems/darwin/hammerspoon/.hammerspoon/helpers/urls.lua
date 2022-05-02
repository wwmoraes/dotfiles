local urls = {}

---@param x string @hexadecimal number of a character
---@return string
local hex_to_char = function(x)
  return string.char(tonumber(x, 16))
end

---@param url string
---@return string
function urls.unescape(url)
  return url:gsub("%%(%x%x)", hex_to_char)
end

return urls
