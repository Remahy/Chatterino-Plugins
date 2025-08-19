require "src/state/settings"
require "constants"

---@param channel c2.Channel
---@param extraText string|nil
function Warn_No_Foo_Provided(channel, foo, extraText)
  channel:add_system_message(RL_UTILS_SYSTEM_MESSAGE_PREFIX .. " No " .. foo .. " provided. " .. extraText)
end

---@param channel c2.Channel
function Warn_No_Logs_Loaded_Into_Split(channel)
  channel:add_system_message(RL_UTILS_SYSTEM_MESSAGE_PREFIX ..
    " No logs have been loaded into this split. Add one using the \"" .. PREFIX .. COMMAND_LOGS .. "\" command.")
end

---@param channel c2.Channel
---@param url string
---@param error string
function Warn_HTTP_Error(channel, url, error)
  channel:add_system_message(RL_UTILS_SYSTEM_MESSAGE_PREFIX .. " Something went wrong reading URL " .. url .. " : " .. error)
end

---@param channel c2.Channel
---@param text string
function Info_System_Message(channel, text)
  channel:add_system_message(RL_UTILS_SYSTEM_MESSAGE_PREFIX .. " " ..text)
end

