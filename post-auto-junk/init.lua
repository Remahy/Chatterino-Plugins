require "utils/parseCommand"
require "constants"
require "post"

local commandSlash = COMMAND_PREFIX .. COMMAND_PAJ

local usageText = [[
Usage syntax: ]] .. commandSlash .. [[ Kappa Keepo 123 <...options?> or type it again to turn off.
]]
local optionsText = [[
Available options: interval=(2200)|number amount=(-1)|number
]]

---@param ctx CommandContext
local paj = function(ctx)
  local channelId = ctx.channel:get_twitch_id()

  if SPAM[channelId] ~= nil then
    SPAM[channelId] = nil
    Info_System_Message(ctx.channel, "Turned off.")
    return
  end

  local command = Parse_Command(ctx, usageText, optionsText)

  if command == nil then
    return
  end

  PAJ(ctx, command)
end

c2.register_command(commandSlash, paj)
