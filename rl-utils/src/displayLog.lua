require "utils"

--- @param split c2.Channel
--- @param log { timestamp: string, channel: string, username: string, message: string }
function Display_Log(split, log)
  local chatMessage = c2.Message.new({
    channel_name = log.channel,
    login_name = log.username,
    elements = {
      {
        type = "text",
        text = "RL-U",
        color = "system",
        style = c2.FontStyle.ChatMediumBold
      },
      {
        type = "text",
        color = "system",
        text = log.timestamp
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
