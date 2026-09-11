require "src/parseCommand"
require "src/systemMessages"
require "src/constants"
require "src/http/links"
require "src/http/logs"
require "src/mm2plHelper"
require "src/io/settingsConstants"
require "src/state/settings"

local commandSlash = PREFIX .. COMMAND_LOGS

local usageText = [[
Usage syntax: ]] .. commandSlash .. [[ <username> <#channel?> <...options?>
]]
local optionsText = [[
Available options: d=(false)|true l=(10)
]]

function Get_Logs_Url(command)
  local url = nil

  if command.username ~= "" and command.channel ~= "" then
    url = Create_Raw_Channel_User_Link(command.channel, command.username, command.options)
  end

  if url == nil then
    url = Create_Raw_Channel_Link(command.channel, command.options)
  end

  return url
end

---@param ctx CommandContext
local handler = function(ctx)
  local command = Parse_Command(ctx, usageText, optionsText)

  if command == nil then
    return
  end

  local url = nil

  if OptionalChain(command.options, "offset") and OptionalChain(command.options, "limit") == nil then
    command.options["limit"] = command.options.l
  end

  url = Get_Logs_Url(command)

  Load_URL(ctx.channel, url, command)
end

c2.register_command(commandSlash, handler)
