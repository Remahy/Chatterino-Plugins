require "src/state/settings"
require "src/utils"

local DEFAULT_IGNORES = { SETTINGS_DIRECT_PROPERTY_NAME }

local join_options = function(options, ignores, joinStr)
  local defaultIgnores = ignores or DEFAULT_IGNORES
  local defaultJoinStr = joinStr or "&"

  local text = ""

  for key, value in pairs(options) do
    if LumeFind(defaultIgnores, key) then
      goto skip
    end

    text = Ternary(#text ~= 0, defaultJoinStr or "&", "") .. key .. "=" .. tostring(value)

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

function Create_Raw_Channel_User_Link(channel, username, options)
  local url = Settings_Read_Instance_Base_Url() ..
      Settings_Read_Instance_Raw_Channel_User():gsub("%%username%%", username):gsub("%%channel%%", channel);

  local joinedOptions = join_options(options)

  return url .. Ternary(joinedOptions ~= "", "?" .. joinedOptions, "")
end
