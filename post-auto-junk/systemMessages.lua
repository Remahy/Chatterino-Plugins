require "constants"

---@param channel c2.Channel
---@param extraText string|nil
function Warn_No_Foo_Provided(channel, foo, extraText)
  channel:add_system_message(PAJ_SYSTEM_MESSAGE_PREFIX .. " No " .. foo .. " provided. " .. extraText)
end

---@param channel c2.Channel
---@param text string
function Info_System_Message(channel, text)
  channel:add_system_message(PAJ_SYSTEM_MESSAGE_PREFIX .. " " ..text)
end
