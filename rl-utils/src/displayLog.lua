require "utils"

--- @param split c2.Channel
--- @param log { timestamp: string, channel: string, username: string, message: string }
function Display_Log(split, log)
  local t = Parse_Timestamp(log.timestamp)

  local timestamp = To_Epoch(t)

  local chatMessage = c2.Message.new({
    channel_name = log.channel,
    login_name = log.username,
    server_received_time = timestamp,
    elements = {
      {
        type = "text",
        text = "RL-U",
        color = "system",
        style = c2.FontStyle.ChatMediumBold
      },
      {
        type = "timestamp",
        time = timestamp
      },
      {
        type = "text",
        color = "system",
        text = "#" .. log.channel
      },
      {
        type = "text",
        text = log.username .. ":"
      },
      {
        type = "text",
        text = log.message
      }
    }
  })

  split:add_message(chatMessage)
end
