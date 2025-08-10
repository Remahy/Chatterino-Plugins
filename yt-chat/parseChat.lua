local json = require "libs/json"

require "buildMessage"
require "mm2plHelper"

---@param action table
local add_chat = function(data, action)
  local videoId = data.videoId

  local splits = Get_Active_Stream_Splits(videoId)

  local item = OptionalChain(action, "addChatItemAction", "item")

  local showChannel = #splits > 0

  if item == nil then
    print("Missing addChatItemAction.item")
    print(json.encode(action))
    return
  end

  local message = Build_Message(data, item, showChannel)

  if message == nil then
    return
  end

  for _, split in ipairs(splits) do
    local channel = c2.Channel.by_name(split)
    if channel then
      -- channel:add_system_message(text)
      channel:add_message(message)
    end
  end
end

---@param youtubeData table
local add_chats = function(data, youtubeData)
  local actions = OptionalChain(youtubeData, "continuationContents", "liveChatContinuation", "actions")

  if actions == nil then
    return
  end

  for _, action in ipairs(actions) do
    add_chat(data, action)
  end
end

---@param youtubeData table
local get_next_continuation = function(youtubeData)
  local nextContinuation = nil

  local CS = OptionalChain(youtubeData, "continuationContents", "liveChatContinuation", "continuations")

  if CS then
    nextContinuation = CS[1]
  end

  local continuation = nil

  if nextContinuation then
    local ICDC = OptionalChain(nextContinuation, "invalidationContinuationData", "continuation")
    local TCDC = OptionalChain(nextContinuation, "timedContinuationData", "continuation")

    continuation = ICDC or TCDC
  end

  if continuation == nil then
    continuation = OptionalChain(youtubeData, "invalidationContinuationData", "continuation")
  end

  return continuation
end

---@param data { channelName:string, channelId:string, videoId:string, apiKey:string, clientVersion:string, continuation:string }
---@param result c2.HTTPResponse
local parse_live_chat_response = function(data, result)
  local videoId = data.videoId

  local status = result:status()

  if status >= 300 then
    Remove_From_Active_Streams(videoId)
    print("Status: '" .. status .. "'. End polling of", videoId)
    return
  end

  local stringJson = result:data()
  local youtubeData = json.decode(stringJson)

  if type(youtubeData) ~= "table" then
    Remove_From_Active_Streams(videoId)
    print("Data from YouTube might not be JSON. End polling of", videoId, "String:", stringJson)
    return
  end

  add_chats(data, youtubeData)

  local splits = Get_Active_Stream_Splits(videoId)

  for _, split in ipairs(splits) do
    local channel = c2.Channel.by_name(split)
    if channel == nil then
      Remove_Split_From_Active_Streams(videoId, split)
    end
  end

  splits = Get_Active_Stream_Splits(videoId)

  if #splits == 0 then
    Remove_From_Active_Streams(videoId)
    print("Lack of splits. End polling of", videoId)
    -- ends the polling
    return
  end

  local newContinuation = get_next_continuation(youtubeData)

  if newContinuation == nil then
    Remove_From_Active_Streams(videoId)
    print("Lack of newContinuation. End polling of", videoId)
    return
  end

  c2.later(function()
    Read_YouTube_Chat(
      {
        continuation = newContinuation,
        videoId = data.videoId,
        apiKey = data.apiKey,
        clientVersion = data.clientVersion,
        channelId = data.channelId,
        channelName = data.channelName
      }
    )
  end, 600)
end

---@param data { channelName:string, channelId:string, videoId:string, apiKey:string, clientVersion:string, continuation:string }
function Read_YouTube_Chat(data)
  local videoId = data.channelId
  local apiKey = data.apiKey
  local clientVersion = data.clientVersion
  local continuation = data.continuation

  local request = c2.HTTPRequest.create(c2.HTTPMethod.Post,
    "https://www.youtube.com/youtubei/v1/live_chat/get_live_chat?key=" .. apiKey)

  Mutate_Request_Default_Headers(request)
  request:set_header("Content-Type", "application/json")

  request:set_payload([[
    {
      "context": {
        "client": {
          "clientVersion": "]] .. clientVersion .. [[",
          "clientName": "WEB"
        }
      },
      "continuation": "]] .. continuation .. [["
    }
  ]])

  request:on_success(function(result) parse_live_chat_response(data, result) end)

  request:on_error(function(result)
    print("Something went wrong reading chat from videoId " ..
      videoId .. " :" .. result:error())
  end)

  request:execute()
end
