local strings = {}

---@param str string
---@param prefix string
---@return boolean
function strings.startsWith(str, prefix)
  return str:find(prefix) == 1
end

---@param str string
---@param prefix string
---@return string
function strings.trimPrefix(str, prefix)
  return str:sub(string.len(prefix) + 1)
end

return strings
