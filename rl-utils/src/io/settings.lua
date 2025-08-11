local inifile = require "src/libs/inifile"

require "src/utils"

local SETTINGS_FILE_NAME = "settings.ini"

SETTINGS_PROPERTY_NAME = "settings"
SETTINGS_INSTANCE_BASE_URL_PROPERT_NAME = "baseUrl"
SETTINGS_INSTANCE_LINK_PROPERTY_NAME = "link"
SETTINGS_INSTANCE_RAW_CHANNEL_USER_PROPERTY_NAME = "rawChannelUser"
SETTINGS_INSTANCE_RAW_CHANNEL_PROPERTY_NAME = "rawChannel"
SETTINGS_PROPERTY_NAME = "settings"
SETTINGS_LIMIT_PROPERTY_NAME = "limit"

local SETTINGS_CONTENT = {
  [SETTINGS_PROPERTY_NAME] = {
    [SETTINGS_INSTANCE_BASE_URL_PROPERT_NAME] = "https://logs.ivr.fi",
    [SETTINGS_INSTANCE_LINK_PROPERTY_NAME] = "/?channel=%channel%&username=%username%",
    [SETTINGS_INSTANCE_RAW_CHANNEL_USER_PROPERTY_NAME] = "/channel/%channel%/user/%username%",
    [SETTINGS_INSTANCE_RAW_CHANNEL_PROPERTY_NAME] = "/channel/%channel%",
    [SETTINGS_LIMIT_PROPERTY_NAME] = 10
  }
}

local settingsFile_create = function()
  local f, e = io.open(SETTINGS_FILE_NAME, "w+")
  assert(f, e)

  f:seek("set", 0)

  f:write(inifile.encode(SETTINGS_CONTENT)):flush()
  f:close()

  return SETTINGS_CONTENT
end

function SettingsFile_Read()
  if FileExists(SETTINGS_FILE_NAME) then
    local f, e = io.open(SETTINGS_FILE_NAME, "r+")
    assert(f, e)

    f:seek("set", 0)
    ---@type string
    local rawFile = f:read("a")

    f:close()

    ---@type table
    return inifile.decode(rawFile)
  end

  return settingsFile_create()
end

---@param settings table
function SettingsFile_Update(settings)
  IO_LOCK = true

  local f, e = io.open(SETTINGS_FILE_NAME, "w+")
  assert(f, e)

  f:seek("set", 0)

  f:write(inifile.encode(settings)):flush()
  f:close()

  IO_LOCK = false
end
