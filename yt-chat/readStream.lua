local json = require "json"

require "utils"
require "streamsFile"
require "parseChat"

---@param data { ["channelId"]:string, ["videoId"]:string, ["apiKey"]:string, ["clientVersion"]:string, ["continuation"]:string }
---@param splits {}
function Initialize_Live_Polling(data, splits)
  Add_To_Active_Streams(data["videoId"], splits)

  print("Heading into polling YouTube Chat with the following data:", json.encode(data))
  Read_YouTube_Chat(data)
end

---@param result c2.HTTPResponse
---@param splits any
local parse_is_live_data = function(result, splits)
  local data, err = Parse_HTML(result)

  if err or data == nil then
    print("Faulty HTML", data, err)
    return
  end

  if Is_Active_Stream_VideoId_Active(data["videoId"]) == false then
    print("Loading " .. data["videoId"] .. " into " .. table.concat(splits, ", "))
    Initialize_Live_Polling(data, splits)
  end
end

---@param channelId string
local getUrl = function(channelId)
  return "https://www.youtube.com/channel/" .. channelId .. "/live"
end

---@param channelId string
---@param splits table
local is_live_request = function(channelId, splits)
  local url = getUrl(channelId)
  print("Checking status of " .. url)
  local request = c2.HTTPRequest.create(c2.HTTPMethod.Get, url)
  Mutate_Request_Default_Headers(request)
  request:on_success(function(result) parse_is_live_data(result, splits) end)
  request:on_error(function(result) print("Something went wrong reading url " .. url .. " :" .. result:error()) end)
  request:execute()
end

function Read_Stream_Data()
  if IO_LOCK == true then
    return
  end

  IO_LOCK = true

  local channelsData = StreamFile_Read_Channels()

  local channelIds = Get_Keys(channelsData)
  for _, channelId in ipairs(channelIds) do
    is_live_request(channelId, channelsData[channelId][SPLITS_PROPERTY_NAME])
  end

  IO_LOCK = false

  --c2.later(Read_Stream_Data, 1000)
end
