local json = require('chatterino.json')

require "utils"
require "streamsFile"
require "parseChat"
require "state"

---@param data { channelName:string, channelId:string, videoId:string, apiKey:string, clientVersion:string, continuation:string }
---@param splits {}
function Initialize_Live_Polling(data, splits)
  Add_To_Active_Streams(data.videoId, splits)

  local ok, result = pcall(json.stringify, data)

  if ok then
    print("Heading into polling YouTube Chat with the following data:", result)
  else
    print("Tried to stringify YouTube Chat Initialize_Live_Polling data:", result)
  end

  Read_YouTube_Chat(data)
end

---@param result c2.HTTPResponse
---@param videoId string
---@param splits table
local parse_is_live_data = function(result, videoId, splits)
  local data, err = Parse_HTML(result)

  if err ~= nil and err ~= "continuation" then
    print("Faulty HTML. Could not find '" .. err .. "' for videoId:", videoId)
    return
  end

  if err == "continuation" then
    -- drop silently, this video isn't live.
    return
  end

  if data == nil then
    -- it will never get here, but linter is complaining.
    print("Clueless data == nil")
    return
  end

  if Is_Active_Stream_VideoId_Active(data.videoId) == false then
    print('Loading "' .. data.videoId .. '" into ' .. table.concat(splits, ", "))
    Initialize_Live_Polling(data, splits)
  end
end

---@param videoId string
local getVideoUrl = function(videoId)
  return "https://www.youtube.com/watch?v=" .. videoId
end

---@param videoId string
---@param splits table
local is_live_request = function(videoId, splits)
  local url = getVideoUrl(videoId)

  local request = c2.HTTPRequest.create(c2.HTTPMethod.Get, url)
  Mutate_Request_Default_Headers(request)

  request:on_success(function(result) parse_is_live_data(result, videoId, splits) end)

  request:on_error(function(result)
    print('is_live_request: Something went wrong reading url "' ..
      url .. '" : ' .. result:error())
  end)

  request:execute()
end

---@param result c2.HTTPResponse
---@param splits table
local parse_is_streaming_data = function(result, splits)
  local videoId, err = Parse_Channel_HTML(result)

  if err == "offline" then
    -- drop silently, this video isn't live.
    return
  end

  if videoId == nil then
    -- it will never get here, but linter is complaining.
    print("Clueless videoId == nil")
    return
  end

  is_live_request(videoId, splits)
end

---@param channelId string
local getChannelUrl = function(channelId)
  return "https://www.youtube.com/channel/" .. channelId .. "/streams"
end

---@param channelId string
---@param splits table
local is_streaming_request = function(channelId, splits)
  local url = getChannelUrl(channelId)

  local request = c2.HTTPRequest.create(c2.HTTPMethod.Get, url)
  Mutate_Request_Default_Headers(request)

  request:on_success(function(result) parse_is_streaming_data(result, splits) end)

  request:on_error(function(result)
    print('is_streaming_request: Something went wrong reading url "' ..
      url .. '" : ' .. result:error())
  end)

  request:execute()
end

function Read_Stream_Data()
  if IO_LOCK then
    c2.later(Read_Stream_Data, OFFLINE_POLL_INTERVAL_MS)
    return
  end

  local channelIds = Get_Keys(Stream_Read_Channels())

  for _, channelId in ipairs(channelIds) do
    local splits = Only_Available_Splits(Stream_Read_Channel(channelId)[STREAMS_SPLITS_PROPERTY_NAME])

    if #splits > 0 then
      is_streaming_request(channelId, splits)
    else
      print("No splits available for", channelId)
    end
  end

  c2.later(Read_Stream_Data, OFFLINE_POLL_INTERVAL_MS)
end
