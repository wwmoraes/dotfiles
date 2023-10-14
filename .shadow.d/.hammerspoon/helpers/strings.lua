local strings = {}

---@param str string
---@param prefix string
---@return boolean
function strings.startsWith(str, prefix)
  return str:find(prefix) == 1
end

function strings.endsWith(str, suffix)
  local startPos, endPos = str:find(suffix)
  return endPos == str:len() and (endPos - startPos + 1) == suffix:len()
end

---@param str string
---@param prefix string
---@return string
function strings.trimPrefix(str, prefix)
  return str:sub(string.len(prefix) + 1)
end

return strings
