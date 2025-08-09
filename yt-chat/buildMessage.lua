local json = require "libs/json"

--To reduce a bunch of repeated code, we have this meta message that has every conceivable field for a message.
---@param message { timestamp: string }
---@return table
local create_message = function(message)
  -- Required fields for all messages, for now.
  local timestamp = message.timestamp
  local elements = {
    {
      type = "text",
      text = "YT",
      color = "system",
      style = c2.FontStyle.ChatMediumBold
    },
    {
      type = "timestamp",
      time = timestamp
    }
  }
  local channel = message["channel"]
  if channel then
    table.insert(
      elements,
      {
        type = "text",
        color = "system",
        text = "(" .. channel .. ")",
        style = c2.FontStyle.Tiny
      }
    )
  end

  local name = message["name"]
  if name then
    table.insert(
      elements,
      {
        type = "text",
        text = name .. ":",
        color = Get_Color(name),
        style = c2.FontStyle.ChatMediumBold
      }
    )
  end

  local text = message["text"]
  if text then
    table.insert(
      elements,
      {
        type = "text",
        text = text
      }
    )
  end

  return elements
end

local chat_poll_action = function()
  return nil
end

---@param textRenderer {}
---@param showChannel boolean
---@return c2.Message
local text_message = function(data, textRenderer, showChannel)
  local channelName = data.channelName


  local name = OptionalChain(textRenderer, "authorName", "text") or
      OptionalChain(textRenderer, "authorName", "simpleText") or "[YouTube chatter]"
  local trimmedName = Trim5(name)

  local messageRuns = OptionalChain(textRenderer, "message", "runs")

  local text = ""

  if messageRuns then
    for _, textRun in ipairs(messageRuns) do
      text = text .. (OptionalChain(textRun, "text") or "")
    end
  end

  ---@type string
  local timestamp = OptionalChain(textRenderer, "timestampUsec") or tostring(os.time())
  local id = OptionalChain(textRenderer, "id")

  local elements = create_message({
    timestamp = timestamp,
    name = trimmedName,
    text = text,
    channel = Ternary(showChannel, channelName, nil)
  })

  local message = c2.Message.new({
    id = "yt-chat-" .. id,
    message_text = text,
    elements = elements
  })

  return message
end

local emoji_reaction = function()
  return nil
end

---@param data {} - initial data
---@param item {} - json
---@param showChannel boolean
function Build_Message(data, item, showChannel)
  -- This is a emoji reaction which users can spam.
  if OptionalChain(item, "liveChatPlaceholderItemRenderer") then
    return emoji_reaction()
  end

  -- item could be anything, but for now we're reading only text
  local textRenderer = OptionalChain(item, "liveChatTextMessageRenderer")
  if textRenderer then
    return text_message(data, textRenderer, showChannel)
  end

  local chatPollAction = OptionalChain(item, "updateLiveChatPollAction")
  if chatPollAction then
    return chat_poll_action()
  end

  print("Hit not handled message type: " .. json.encode(item))

  return nil
end
