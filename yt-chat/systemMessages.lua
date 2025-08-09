require "constants"

---@param channel c2.Channel
function Warn_No_URL_Provided(channel)
  channel:add_system_message(YT_CHAT_SYSTEM_MESSAGE_PREFIX .. "No URL provided!")
end

---@param channel c2.Channel
---@param url string
function Warn_URL_Not_YouTube(channel, url)
  channel:add_system_message(YT_CHAT_SYSTEM_MESSAGE_PREFIX ..
    "Not valid YouTube URL: " .. url .. " URLs must start with \"https://www.youtube.com/\"")
end

---@param channel c2.Channel
---@param url string
function Warn_Faulty_URL(channel, url)
  channel:add_system_message(YT_CHAT_SYSTEM_MESSAGE_PREFIX .. "Faulty URL: " .. url)
end

---@param channel c2.Channel
---@param url string
---@param code number|nil
function Warn_Status_Not_200_URL(channel, url, code)
  channel:add_system_message(YT_CHAT_SYSTEM_MESSAGE_PREFIX .. "URL: " .. url .. " returned status code: " .. code)
end

---@param channel c2.Channel
---@param url string
function Warn_No_VideoId(channel, url)
  channel:add_system_message(YT_CHAT_SYSTEM_MESSAGE_PREFIX .. "Couldn't find videoId while parsing HTML in URL: " .. url)
end

---@param channel c2.Channel
---@param url string
function Warn_No_ApiKey(channel, url)
  channel:add_system_message(YT_CHAT_SYSTEM_MESSAGE_PREFIX ..
    "Couldn't find INNERTUBE_API_KEY while parsing HTML. " .. url)
end

---@param channel c2.Channel
---@param url string
function Warn_No_Continuation(channel, url)
  channel:add_system_message(YT_CHAT_SYSTEM_MESSAGE_PREFIX ..
    "Couldn't find continuation for this URL: " ..
    url ..
    " This may mean this URL isn't a livestream yet. Saving channel for now. Will load chat once a stream on the channel is live.")
end

---@param channel c2.Channel
---@param url string
function Warn_No_Channel_Id(channel, url)
  channel:add_system_message(YT_CHAT_SYSTEM_MESSAGE_PREFIX ..
    "Couldn't find channel id for this URL: " .. url)
end

---@param channel c2.Channel
---@param url string
function Warn_No_Client_Version(channel, url)
  channel:add_system_message(YT_CHAT_SYSTEM_MESSAGE_PREFIX ..
    "Couldn't find client version for this URL: " .. url)
end

---@param channel c2.Channel
---@param streamer string
---@param split string
function Warn_Split_Already_Added(channel, streamer, split)
  channel:add_system_message(YT_CHAT_SYSTEM_MESSAGE_PREFIX ..
    "Channel '" .. streamer .. "' has already been added to split '" .. split .. "'")
end

---@param channel c2.Channel
function Warn_IO_Busy(channel)
  channel:add_system_message(YT_CHAT_SYSTEM_MESSAGE_PREFIX ..
    "Please try again in a bit, IO is currently busy...")
end

---@param channel c2.Channel
function Warn_Channel_Name(channel)
  channel:add_system_message(YT_CHAT_SYSTEM_MESSAGE_PREFIX ..
    "This command cannot be run in a split with this name '" .. channel:get_name() .. "'. Try renaming it and try again.")
end

---@param channel c2.Channel
---@param url string
function Log_Reading_URL(channel, url)
  channel:add_system_message(YT_CHAT_SYSTEM_MESSAGE_PREFIX .. "Reading URL: " .. url)
end
