require "src/state/loadedChats"
require "src/state/settings"
require "displayLog"
require "utils"
require "constants"

---@param line string
local parse_line = function(line)
  -- [2025-05-03 11:31:50] #pajlada karar: ALLO CHA, ALLO PAJ
  local pattern = "%[([%d%-:%s]+)%]%s#(%S+)%s(%S+):%s(.+)"

  local timestamp, channel, username, message = line:match(pattern)

  if timestamp == nil or channel == nil or username == nil or message == nil then
    return nil
  end

  return {
    timestamp = timestamp,
    channel = channel,
    username = username,
    message = message,
  }
end

---@param split c2.Channel
local offline_parse = function(split, splitData)
  local data = splitData.data
  local options = splitData.options

  local l = (tonumber(options.l) or 10) - 1
  local o = (tonumber(options.o) or 0)

  local from = o + 1
  local to = l + from

  for i = from, to do
    local result = parse_line(data[i])

    if result then
      Display_Log(split, result)
    else
      print("Faulty log?", data[i])
    end
  end

  Info_System_Message(split,
    "(" .. Ternary(from == 1, 1, from-1) .. "-" .. to .. " of " .. #data .. ")" ..
    " Type " .. PREFIX .. COMMAND_NEXT .. " or " .. PREFIX .. COMMAND_PREV)
end

--- @param split c2.Channel
local online_parse = function(split, splitData)
  local data = splitData.data

  for i = 1, #data do
    local result = parse_line(data[i])

    if result then
      Display_Log(split, result)
    else
      print("Faulty log?", data[i])
    end
  end

  splitData.data = nil
  Loaded_Chat_Set(split:get_name(), splitData)
end

--- @param split c2.Channel
function Parse_Logs(split)
  local splitData = Loaded_Chat_Get(split:get_name())

  Info_Divider(split)

  if splitData.offline then
    offline_parse(split, splitData)
  else
    -- Online parsing is basically loading the received data, but we delete the data once it's parsed.
    online_parse(split, splitData)
    Info_System_Message(split, splitData.url)
  end
end
