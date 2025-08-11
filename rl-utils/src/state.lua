require "io/settings"

SETTINGS = SettingsFile_Read()

function Settings_Read_Settings()
  return {
    [SETTINGS_LIMIT_PROPERTY_NAME] = SETTINGS[SETTINGS_PROPERTY_NAME][SETTINGS_LIMIT_PROPERTY_NAME]
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
