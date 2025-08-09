require "utils"
require "streamsFile"

IO_LOCK = false

ACTIVE_STREAMS = {}

---@param videoId string
---@param splits table
function Add_To_Active_Streams(videoId, splits)
  ACTIVE_STREAMS[videoId] = splits
end

---@param videoId string
function Is_Active_Stream_VideoId_Active(videoId)
  return Table_Has_Value(ACTIVE_STREAMS, videoId)
end

function Get_Active_Stream_Splits(videoId)
  return ACTIVE_STREAMS[videoId]
end

---@param videoId string
function Remove_From_Active_Streams(videoId)
  ACTIVE_STREAMS[videoId] = nil
end

---@param videoId string
---@param split string
function Remove_Split_From_Active_Streams(videoId, split)
  if Is_Active_Stream_VideoId_Active(videoId) then
    local index = LumeFind(ACTIVE_STREAMS[videoId], split)
    table.remove(ACTIVE_STREAMS[videoId], index)

    if #ACTIVE_STREAMS[videoId] == 0 then
      Remove_From_Active_Streams(videoId)
    end
  end
end

STREAMS_DATA = StreamFile_Read()

---@param channel string
---@param split string
function Stream_Create_Channel(channel, split)
  STREAMS_DATA[STREAMS_CHANNELS_PROPERTY_NAME][channel] = {
    [STREAMS_SPLITS_PROPERTY_NAME] = { split }
  }

  return { split }
end

function Stream_Read_Channels()
  return STREAMS_DATA[STREAMS_CHANNELS_PROPERTY_NAME]
end

---@param channel string
function Stream_Read_Channel(channel)
  local channels = Stream_Read_Channels()

  return OptionalChain(channels, channel)
end

---@param channel string
---@param split string
function Stream_Add_Split_To_Channel(channel, split)
  local splits = OptionalChain(STREAMS_DATA, STREAMS_CHANNELS_PROPERTY_NAME, channel, STREAMS_SPLITS_PROPERTY_NAME)

  if splits ~= nil then
    table.insert(STREAMS_DATA[STREAMS_CHANNELS_PROPERTY_NAME][channel][STREAMS_SPLITS_PROPERTY_NAME], split)
  else
    STREAMS_DATA[STREAMS_CHANNELS_PROPERTY_NAME][channel][STREAMS_SPLITS_PROPERTY_NAME] = { split }
  end

  return STREAMS_DATA[STREAMS_CHANNELS_PROPERTY_NAME][channel][STREAMS_SPLITS_PROPERTY_NAME]
end

---@param channelData string
---@param split string
function StreamData_Has_Split(channelData, split)
  local index = LumeFind(channelData[STREAMS_SPLITS_PROPERTY_NAME], split)
  return type(index) == "number"
end
