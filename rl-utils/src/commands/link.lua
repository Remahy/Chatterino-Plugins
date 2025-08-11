require "src/parseCommand"
require "src/systemMessages"
require "src/state"

local command = "/rl-link"

local usageText = [[
Usage syntax: ]] .. command .. [[ <username> <#channel?> <...options?>
]]
local optionsText = [[
Available options: raw=(false)|true
]]

local create_link_url = function(username, channel)
  return Settings_Read_Instance_Base_Url() ..
      Settings_Read_Instance_Link():gsub("%%username%%", username):gsub("%%channel%%", channel)
end

local create_raw_channel_link = function(channel)
  return Settings_Read_Instance_Base_Url() ..
      Settings_Read_Instance_Raw_Channel():gsub("%%channel%%", channel)
end

---@param ctx CommandContext
local handler = function(ctx)
  local c = Parse_Command(ctx, usageText, optionsText)

  if c == nil then
    return
  end

  local url = nil

  if c.username ~= "" and c.channel ~= nil then
    url = create_link_url(c.username, c.channel)
  elseif c.channel ~= nil then
    url = create_raw_channel_link(c.channel)
  end


  if url == nil then
    url = create_raw_channel_link(c.channel)
  end

  Info_System_Message(ctx.channel, url)
end

c2.register_command(command, handler)
