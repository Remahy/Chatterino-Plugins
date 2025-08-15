require "src/parseCommand"
require "src/systemMessages"
require "src/state"
require "src/mm2plHelper"

local commandSlash = "/rl-link"

local usageText = [[
Usage syntax: ]] .. commandSlash .. [[ <username> <#channel?> <...options?>
]]
local optionsText = [[
Available options: raw=(false)|true
]]

local create_link_url = function(channel, username)
  return Settings_Read_Instance_Base_Url() ..
      Settings_Read_Instance_Link():gsub("%%username%%", username):gsub("%%channel%%", channel)
end

local create_raw_channel_link = function(channel)
  return Settings_Read_Instance_Base_Url() ..
      Settings_Read_Instance_Raw_Channel():gsub("%%channel%%", channel)
end

local create_raw_channel_user_link = function(channel, username)
  return Settings_Read_Instance_Base_Url() ..
      Settings_Read_Instance_Raw_Channel_User():gsub("%%username%%", username):gsub("%%channel%%", channel)
end

---@param ctx CommandContext
local handler = function(ctx)
  local command = Parse_Command(ctx, usageText, optionsText)

  if command == nil then
    return
  end

  local url = nil

  if command.username ~= "" and command.channel ~= nil then
    url = create_link_url(command.channel, command.username)
  elseif command.channel ~= nil then
    url = create_raw_channel_link(command.channel)
  end

  if OptionalChain(command, "options", "raw") ~= nil and command.username ~= "" then
    url = create_raw_channel_user_link(command.channel, command.username)
  elseif OptionalChain(command, "options", "raw") ~= nil and command.username == "" then
    Warn_No_Foo_Provided(ctx.channel, "username", usageText)
    return
  end

  if url == nil then
    url = create_raw_channel_link(command.channel)
  end

  Info_System_Message(ctx.channel, "Link: " .. url)
end

c2.register_command(commandSlash, handler)
