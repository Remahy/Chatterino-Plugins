---@type { ["splitName"]: { username: string, channel: string, data: string[], options: table, offline: true|nil, url: string } }
LOADED_CHATS = {}

---@param splitName string
function Loaded_Chat_Get(splitName)
  return LOADED_CHATS[splitName]
end

---@param splitName string
---@param data { username: string, channel: string, data: string[], options: table, offline: true|nil, url: string }
function Loaded_Chat_Set(splitName, data)
  LOADED_CHATS[splitName] = data
end
