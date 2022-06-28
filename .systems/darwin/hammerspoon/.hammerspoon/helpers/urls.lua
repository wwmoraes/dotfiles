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

-- converts a part to be URL-safe
-- WARNING: This isn't as complete as the JS version
---@param part string
---@return string
function urls.encodeURIComponent(part)
  return part:
      gsub("/", "%%2F"):
      gsub("=", "%%3D"):
      gsub("&", "%%26"):
      gsub("?", "%%3F"):
      gsub("#", "%%23"):
      gsub('"', "%%22"):
      gsub("'", "%%27"):
      gsub(":", "%%3A"):
      gsub("@", "%%40")
end

---@param base string
---@param path? string
---@param params? table<string,string>
---@return string
function urls.build(base, path, params)
  local url = base
  if type(path) == "string" then
    url = url .. "/" .. path
  end
  if type(params) == "table" then
    local elements = {}
    for k, v in pairs(params) do
      table.insert(elements, k .. "=" .. urls.encodeURIComponent(v))
    end
    url = url .. "?" .. table.concat(elements, "&")
  end
  return url
end

return urls
