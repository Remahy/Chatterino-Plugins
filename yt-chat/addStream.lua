require "systemMessages"

---@param channel c2.Channel
---@param data { channelName:string, channelId:string, videoId:string, apiKey:string, clientVersion:string, continuation:string }
local initialize_add_stream = function(channel, data)
  local videoId = data.videoId
  local channelId = data.channelId
  local continuation = data.continuation

  local split = channel:get_name()

  local channelData = Stream_Read_Channel(channelId)

  if channelData ~= nil then
    local hasSplit = StreamData_Has_Split(channelData, split)
    if hasSplit then
      Warn_Split_Already_Added(channel, channelId, split)
      return
    end

    local splits = Stream_Add_Split_To_Channel(channelId, split)

    if continuation then
      Add_To_Active_Streams(videoId, splits)
    end

    StreamFile_Update(STREAMS_DATA)

    return
  end

  local splits = Stream_Create_Channel(channelId, split)

  if continuation then
    Initialize_Live_Polling(data, splits)
  end

  StreamFile_Update(STREAMS_DATA)
end

---@param channel c2.Channel
---@param url string
---@param result c2.HTTPResponse
local parse_data = function(channel, url, result)
  local data, err = Parse_HTML(result)

  if err == "videoId" then
    Warn_No_VideoId(channel, url)
    return
  end

  if err == "apiKey" then
    Warn_No_ApiKey(channel, url)
    return
  end

  if err == "channelId" then
    Warn_No_Channel_Id(channel, url)
    return
  end

  if err == "clientVersion" then
    Warn_No_Client_Version(channel, url)
    return
  end

  -- This is fine, user might just be adding the channel.
  if err == "continuation" then
    Warn_No_Continuation(channel, url)
  end

  return data
end

---@param result c2.HTTPResponse
local handle_result = function(channel, url, result)
  local status = result:status()

  if status ~= 200 then
    Warn_Status_Not_200_URL(channel, url, status)
    return
  end

  local data = parse_data(channel, url, result)

  if data then
    initialize_add_stream(channel, data)
  end
end

---@param channel c2.Channel
---@param url string
function Initialize_URL(channel, url)
  local request = c2.HTTPRequest.create(c2.HTTPMethod.Get, url)

  Mutate_Request_Default_Headers(request)

  request:on_success(function(result) handle_result(channel, url, result) end)

  request:on_error(function(result)
    print("Something went wrong reading url " .. url .. " :" .. result:error())
    Warn_Faulty_URL(channel, url)
  end)

  request:execute()
end
