require "state"

---@param words string[]
local parse_options = function(words)
  local options = Settings_Read_Settings()

  local count = 0

  for i = 1, #words, 1 do
    if words[i]:match("=") == nil then
      goto finish
    end

    local t = String_Split(words[i], "[^=]*")

    if #t > 1 then
      local key = t[1]
      local value = t[2]

      options[key] = value

      count = count + 1
    end
  end

  ::finish::

  return { options = options, count = count }
end

---@param ctx CommandContext
---@param usageText string
---@param optionsText string
function Parse_Command(ctx, usageText, optionsText)
  if #ctx.words == 1 then
    Warn_No_Foo_Provided(ctx.channel, "arguments", usageText)
    if optionsText then
      Info_System_Message(ctx.channel, optionsText)
    end
    return
  end

  local words = { table.unpack(ctx.words, 2, #ctx.words) }
  local channel = ctx.channel

  ---@type string|nil
  local maybeUsername = words[1]

  if maybeUsername == nil then
    Warn_No_Foo_Provided(channel, "username", usageText)

    if optionsText then
      Info_System_Message(channel, optionsText)
    end

    return
  end

  local ch = ""
  local username = ""
  local options = nil
  local restStr = ""

  -- /command username
  if maybeUsername:sub(1, 1) ~= "#" then
    username = maybeUsername
  elseif maybeUsername:sub(1, 1) == "#" then
    -- /command #channel
    ch = maybeUsername:sub(2)
  end

  -- /command #channel username?
  if username == "" and words[2] and words[2]:sub(1, 1) ~= "#" and words[2]:match("=") == nil then
    username = words[2]
  end

  -- /channel username #channel?
  if ch == "" and words[2] and words[2]:match("=") == nil and words[2]:sub(1, 1) == "#" then
    ch = words[2]:sub(2)
  end

  if ch == "" and channel:get_name() then
    ch = channel:get_name()
  end

  if ch == "" then
    Warn_No_Foo_Provided(channel, "channel", usageText)
    return
  end

  -- /command username <...options?> <...search terms?>
  if words[2] and words[2]:match("=") then
    local newWords = { table.unpack(words, 2, #words) }
    local o = parse_options(newWords)
    local count = o.count
    options = o.options

    restStr = table.concat({ table.unpack(words, 2 + count, #words) }, " ")
  end

  if options == nil and words[3] and words[3]:match("=") then
    local newWords = { table.unpack(words, 3, #words) }
    local o = parse_options(newWords)
    local count = o.count
    options = o.options

    restStr = table.concat({ table.unpack(words, 3 + count, #words) }, " ")
  end

  return {
    username = username,
    channel = ch,
    options = options,
    restStr = restStr
  }
end
