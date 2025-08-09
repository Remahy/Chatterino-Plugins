require "utils"
require "systemMessages"
require "addStream"
require "readStream"

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

  Initialize_URL(channel, url)
end

c2.register_command("/yt-chat", cmd_yt_chat)

c2.later(Read_Stream_Data, 1000)
