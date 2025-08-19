require "src/state/loadedChats"
require "displayLog"
require "utils"

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
---@param data string[]
local offline_parse = function(split, data, options)
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
end

local online_parse = function(split, data)
    for i = 1, #data do
    local result = parse_line(data[i])

    if result then
      Display_Log(split, result)
    else
      print("Faulty log?", data[i])
    end
  end
end

--- @param split c2.Channel
function Parse_Logs(split)
  local options = Loaded_Chat_Get(split:get_name())
  local data = options.data

  if options.offline then
    offline_parse(split, data, options)
    return
  end

  -- Online parsing is basically loading the received data
  online_parse(split, data)
end
