require "utils"
require "state"
require "systemMessages"
require "streamsFile"
require "addStream"
require "readStream"

--local message_id_cache = {}
--local add_to_message_id_cache = function (id)
-- message_id_cache[# message_id_cache+1] = id
--end

---@param ctx CommandContext
local cmd_yt_chat = function(ctx)
  local channel = ctx.channel

  if Trim5(channel:get_name()) == "" then
    Warn_Channel_Name(channel)
    return
  end

  if #ctx.words == 1 then
    Warn_No_URL_Provided(channel)
    return
  end

  local url = ctx.words[2]

  if Is_Valid_URL(url) == false then
    Warn_URL_Not_YouTube(channel, url)
    return
  end

  Log_Reading_URL(channel, url)

  if IO_LOCK then
    Warn_IO_Busy(channel)
    return
  end

  IO_LOCK = true
  Initialize_URL(channel, url)
end

c2.register_command("/yt-chat", cmd_yt_chat)

StreamFile_Create_If_Not_Exists()
c2.later(Read_Stream_Data, 1000)
