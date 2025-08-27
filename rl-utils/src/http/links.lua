require "src/state/settings"
require "src/utils"

local DEFAULT_IGNORES = { SETTINGS_DIRECT_PROPERTY_NAME, SETTINGS_LIMIT_PROPERTY_NAME, "o" }

local join_options = function(options, ignores, joinStr)
  local defaultIgnores = ignores or DEFAULT_IGNORES
  local defaultJoinStr = joinStr or "&"

  local text = ""

  for key, value in pairs(options) do
    if LumeFind(defaultIgnores, key) then
      goto skip
    end

    text = text .. Ternary(#text ~= 0, defaultJoinStr or "&", "") .. key .. "=" .. tostring(value)

    ::skip::
  end

  return text
end

function Create_Link_Url(channel, username)
  return Settings_Read_Instance_Base_Url() ..
      Settings_Read_Instance_Link():gsub("%%username%%", username):gsub("%%channel%%", channel)
end

function Create_Raw_Channel_Link(channel, options)
  local url = Settings_Read_Instance_Base_Url() .. Settings_Read_Instance_Raw_Channel():gsub("%%channel%%", channel)

  local joinedOptions = join_options(options)

  return url .. Ternary(joinedOptions ~= "", "?" .. joinedOptions, "")
end

---@param channel string
---@param username string
---@return string
function Create_Raw_Channel_User_Link(channel, username, options)
  local url = nil

  if username:match(":") then
    local _username = String_Split(username, "[^:]*")[2]

    url = Settings_Read_Instance_Base_Url() ..
        Settings_Read_Instance_Raw_Channel_Userid():gsub("%%username%%", _username):gsub("%%channel%%", channel);
  else
    url = Settings_Read_Instance_Base_Url() ..
        Settings_Read_Instance_Raw_Channel_User():gsub("%%username%%", username):gsub("%%channel%%", channel);
  end

  local joinedOptions = join_options(options)

  return url .. Ternary(joinedOptions ~= "", "?" .. joinedOptions, "")
end
