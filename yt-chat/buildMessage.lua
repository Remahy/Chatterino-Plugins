local json = require('chatterino.json')

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

  local textRuns = message["textRuns"]
  if textRuns then
    for _, textRun in ipairs(textRuns) do
      local image = textRun["image"]

      if image then
        local c2Image = c2.Image.from_url(image)
        table.insert(
          elements,
          {
            type = "image",
            image = c2Image
          }
        )
      end

      local text = textRun["text"]
      if text then
        table.insert(
          elements,
          {
            type = "text",
            text = text
          }
        )
      end
    end
  end

  return elements
end

local chat_poll_action = function()
  return nil
end

local parse_text_message_run = function(textRun)
  local text = OptionalChain(textRun, "text")
  if text then
    return { text }
  end

  local emoji = OptionalChain(textRun, "emoji")
  if emoji then
    local entry = OptionalChain(emoji, "image", "thumbnails")
    local _text = OptionalChain(emoji, "searchTerms") or {}
    if entry then
      local _entry = entry[1]
      local url = _entry["url"]
      local width = entry["width"]
      local height = entry["width"]
      return { text = table.concat(_text, " "), image = url, size = { width, height } }
    end
  end

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

  local textRuns = {}
  local text = ""

  if messageRuns then
    for _, textRun in ipairs(messageRuns) do
      local parsed_run = parse_text_message_run(textRun)

      table.insert(textRuns, parsed_run)
      text = text .. (OptionalChain(parsed_run, "text") or "")
    end
  end

  ---@type string
  local timestamp = OptionalChain(textRenderer, "timestampUsec") or tostring(os.time())
  local id = OptionalChain(textRenderer, "id")

  local elements = create_message({
    timestamp = timestamp,
    name = trimmedName,
    textRuns = textRuns,
    channel = Ternary(showChannel, channelName, nil)
  })

  local message = c2.Message.new({
    id = "yt-chat-" .. id,
    message_text = text,
    elements = elements,
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

  local ok, result = pcall(json.stringify, item)

  if ok then
    print("Hit not handled message type: " .. result)
  else
    print("Tried to stringify a not handled message type", result)
  end

  return nil
end
