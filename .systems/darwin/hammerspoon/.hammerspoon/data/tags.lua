--- reads the tags from the current host tagsrc file

local tagsrc = os.getenv("TAGSRC") or os.getenv("HOME") .. "/.tagsrc"

---@type string[]
local tags = {}

local fd, err = io.open(tagsrc)
if fd == nil or err ~= nil then
  return tags
end

for tag in fd:lines() do
  table.insert(tags, tag)
end
fd:close()

return tags
