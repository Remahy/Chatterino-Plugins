local inifile = require "src/libs/inifile"

require "src/io/settingsConstants"
require "src/utils"

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
