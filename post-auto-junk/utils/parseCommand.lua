require "utils/stringSplit"
require "utils/hasValue"
require "utils/trim4"
require "systemMessages"

function Default_Options()
  return {
    interval = 2200,
    amount = -1,
  }
end

local valid_options = { "interval", "amount" }

---@param word string
local parse_option = function(word)
  if word:match("=") == nil then
    return false
  end

  local t = String_Split(word, "[^=]*")

  if #t ~= 2 then
    return false
  end

  local key = t[1]
  local value = t[2]

  if HasValue(valid_options, key) == false then
    return false
  end

  return { key = key, value = value }
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

  local options = Default_Options()
  local restStr = ""

  for i = 1, #words, 1 do
    local word = words[i]

    local option = parse_option(word)

    if option ~= false then
      local key = option.key
      local value = option.value
      options[key] = value
    else
      restStr = restStr .. " " .. word
    end
  end

  if #restStr == 0 then
    Warn_No_Foo_Provided(ctx.channel, "text to spam", usageText)
    return
  end

  return {
    options = options or Default_Options(),
    restStr = Trim4(restStr)
  }
end
