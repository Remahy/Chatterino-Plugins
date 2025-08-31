SPAM = {}

Spam = function(channelId)
  if SPAM[channelId] == nil then
    return
  end

  local s = SPAM[channelId]

  ---@type { restStr: string, options: {} }
  local command = s.command

  local channel = c2.Channel.by_twitch_id(channelId);

  if channel == nil then
    return
  end

  channel:send_message(command.restStr)

  if command.options.amount == 0 then
    return
  end

  command.options.amount = command.options.amount - 1

  local interval = command.options.interval or Default_Options().interval

  c2.later(function () Spam(channelId) end, tonumber(interval) or 2200)
end

---@param ctx CommandContext
---@param command { restStr: string, options: {} }
function PAJ(ctx, command)
  ctx.channel:send_message("Hey, everyone, I am doing something very silly!")

  local interval = command.options.interval or Default_Options().interval

  command.options.amount = command.options.amount - 1

  local channelId = ctx.channel:get_twitch_id()

  SPAM[channelId] = { command = command }

  c2.later(function() Spam(channelId) end, tonumber(interval) or 2200)
end
