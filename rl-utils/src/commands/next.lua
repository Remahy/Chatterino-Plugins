require "src/state/loadedChats"
require "src/http/logs"
require "src/constants"
require "src/systemMessages"
require "src/parseLogs"
require "logs"

local commandSlash = PREFIX .. COMMAND_NEXT

---@param ctx CommandContext
local handler = function(ctx)
  local splitName = ctx.channel:get_name()

  local splitData = Loaded_Chat_Get(splitName)

  if splitData == nil then
    Warn_No_Logs_Loaded_Into_Split(ctx.channel)
    return
  end

  if splitData.offline == nil then
    if OptionalChain(splitData.options, "offset") ~= nil then
      splitData.options["offset"] = splitData.options["offset"] + (splitData.options["limit"] or splitData.l)
    end

    local url = Get_Logs_Url(splitData)
    splitData.url = url

    Loaded_Chat_Set(splitName, splitData)
    Load_URL(ctx.channel, splitData.url, splitData)
    return
  end


  local newOffset = splitData.options.o + splitData.options.l

  if newOffset > #splitData.data then
    Warn_Out_Of_Bounds(ctx.channel)
    return
  end

  splitData.options.o = newOffset
  Loaded_Chat_Set(splitName, splitData)
  Parse_Logs(ctx.channel)
end

c2.register_command(commandSlash, handler)
