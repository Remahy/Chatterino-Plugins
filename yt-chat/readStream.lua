local json = require "libs/json"

require "utils"
require "streamsFile"
require "parseChat"
require "state"

---@param data { channelName:string, channelId:string, videoId:string, apiKey:string, clientVersion:string, continuation:string }
---@param splits {}
function Initialize_Live_Polling(data, splits)
  Add_To_Active_Streams(data.videoId, splits)

  print("Heading into polling YouTube Chat with the following data:", json.encode(data))
  Read_YouTube_Chat(data)
end

---@param result c2.HTTPResponse
---@param splits any
local parse_is_live_data = function(result, splits)
  local data, err = Parse_HTML(result)

  if (err == nil or err ~= "continuation") and type(data) ~= "table" then
    print("Faulty HTML", "data is", type(data), "err is", err)
    return
  end

  if data == nil then
    -- it will never get here, but linter is complaining.
    print("Clueless data == nil")
    return
  end

  if err == "continuation" then
    -- drop silently, this video isn't live.
    print("Dropping", json.encode(data))
    return
  end

  if Is_Active_Stream_VideoId_Active(data.videoId) == false then
    local videoId = data.videoId

    print("Loading " .. videoId .. " into " .. table.concat(splits, ", "))
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
  local request = c2.HTTPRequest.create(c2.HTTPMethod.Get, url)
  Mutate_Request_Default_Headers(request)
  request:on_success(function(result) parse_is_live_data(result, splits) end)
  request:on_error(function(result) print("Something went wrong reading url " .. url .. " :" .. result:error()) end)
  request:execute()
end

function Read_Stream_Data()
  if IO_LOCK then
    return
  end

  local channelIds = Get_Keys(Stream_Read_Channels())

  for _, channelId in ipairs(channelIds) do
    local splits = Only_Available_Splits(Stream_Read_Channel(channelId)[STREAMS_SPLITS_PROPERTY_NAME])

    if #splits > 0 then
      is_live_request(channelId, splits)
    else
      print("No splits available for", channelId)
    end
  end

  c2.later(Read_Stream_Data, 1000)
end
