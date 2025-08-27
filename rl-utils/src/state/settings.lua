require "src/io/settingsConstants"
require "src/io/settings"

SETTINGS = SettingsFile_Read()

PREFIX = SETTINGS[SETTINGS_PROPERTY_NAME][SETTINGS_COMMAND_PREFIX_PROPERTY_NAME]

function Settings_Read_Settings()
  return {
    [SETTINGS_COMMAND_PREFIX_PROPERTY_NAME] = PREFIX,
    [SETTINGS_LIMIT_PROPERTY_NAME] = SETTINGS[SETTINGS_PROPERTY_NAME][SETTINGS_LIMIT_PROPERTY_NAME],
    [SETTINGS_DIRECT_PROPERTY_NAME] = SETTINGS[SETTINGS_PROPERTY_NAME][SETTINGS_DIRECT_PROPERTY_NAME],
  }
end

function Settings_Read_Default_Options()
  return {
    [SETTINGS_LIMIT_PROPERTY_NAME] = SETTINGS[SETTINGS_PROPERTY_NAME][SETTINGS_LIMIT_PROPERTY_NAME],
    ["o"] = 0, -- "virtual" property
  }
end

---@return string
function Settings_Read_Instance_Base_Url()
  ---@diagnostic disable-next-line: return-type-mismatch
  return SETTINGS[SETTINGS_PROPERTY_NAME][SETTINGS_INSTANCE_BASE_URL_PROPERT_NAME]
end

---@return string
function Settings_Read_Instance_Link()
  ---@diagnostic disable-next-line: return-type-mismatch
  return SETTINGS[SETTINGS_PROPERTY_NAME][SETTINGS_INSTANCE_LINK_PROPERTY_NAME]
end

---@return string
function Settings_Read_Instance_Raw_Channel()
  ---@diagnostic disable-next-line: return-type-mismatch
  return SETTINGS[SETTINGS_PROPERTY_NAME][SETTINGS_INSTANCE_RAW_CHANNEL_PROPERTY_NAME]
end

---@return string
function Settings_Read_Instance_Raw_Channel_User()
  ---@diagnostic disable-next-line: return-type-mismatch
  return SETTINGS[SETTINGS_PROPERTY_NAME][SETTINGS_INSTANCE_RAW_CHANNEL_USER_PROPERTY_NAME]
end

---@return string
function Settings_Read_Instance_Raw_Channel_Userid()
  ---@diagnostic disable-next-line: return-type-mismatch
  return SETTINGS[SETTINGS_PROPERTY_NAME][SETTINGS_INSTANCE_RAW_CHANNEL_USERID_PROPERTY_NAME]
end
