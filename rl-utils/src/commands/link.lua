require "src/parseCommand"
require "src/systemMessages"
require "src/mm2plHelper"
require "src/http/links"
require "src/state/settings"
require "src/io/settingsConstants"

local commandSlash = PREFIX .. "link"

local usageText = [[
Usage syntax: ]] .. commandSlash .. [[ <username> <#channel?> <...options?>
]]
local optionsText = [[
Available options: r=(false)|true
]]

---@param ctx CommandContext
local handler = function(ctx)
  local command = Parse_Command(ctx, usageText, optionsText)

  if command == nil then
    return
  end

  local url = nil

  if command.username ~= "" and command.channel ~= nil then
    url = Create_Link_Url(command.channel, command.username)
  elseif command.channel ~= nil then
    url = Create_Raw_Channel_Link(command.channel, command.options)
  end

  if OptionalChain(command, "options", SETTINGS_DIRECT_PROPERTY_NAME) ~= nil and command.username ~= "" then
    url = Create_Raw_Channel_User_Link(command.channel, command.username, command.options)
  elseif OptionalChain(command, "options", SETTINGS_DIRECT_PROPERTY_NAME) ~= nil and command.username == "" then
    Warn_No_Foo_Provided(ctx.channel, "username", usageText)
    return
  end

  if url == nil then
    url = Create_Raw_Channel_Link(command.channel, command.options)
  end

  Info_System_Message(ctx.channel, "Link: " .. url)
end

c2.register_command(commandSlash, handler)
