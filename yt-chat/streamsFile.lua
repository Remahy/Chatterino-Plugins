local json = require('chatterino.json')

require "constants"
require "mm2plHelper"
require "utils"

local STREAMS_FILE_NAME = "YT_CHAT.json"
local STREAMS_FILE_TEMP_NAME = STREAMS_FILE_NAME .. ".tmp"
local STREAMS_FILE_BACKUP_NAME = STREAMS_FILE_NAME .. ".bak"
local STREAMS_FILE_DEFAULT_CONTENT = [[{
  "]] .. STREAMS_SETTINGS_PROPERTY_NAME .. [[": {},
  "]] .. STREAMS_CHANNELS_PROPERTY_NAME .. [[": {}
}]]

local streamFile_create = function()
  local f, e = io.open(STREAMS_FILE_NAME, "w+")
  assert(f, e)

  f:seek("set", 0)

  f:write(STREAMS_FILE_DEFAULT_CONTENT):flush()
  f:close()

  ---@type table
  return json.parse(STREAMS_FILE_DEFAULT_CONTENT)
end

function StreamFile_Read()
  if FileExists(STREAMS_FILE_NAME) then
    local f, e = io.open(STREAMS_FILE_NAME, "r+")
    assert(f, e)

    f:seek("set", 0)
    ---@type string
    local rawFile = f:read("a")

    f:close()

    ---@type table
    return json.parse(rawFile)
  end

  return streamFile_create()
end

---@param data table
function StreamFile_Update(data)
  IO_LOCK = true

  local ok, result = pcall(json.stringify, data, { pretty = true })

  if ok == false then
    print("Tried updating StreamFile", result)
    IO_LOCK = false
    return false
  end

  local f, e = io.open(STREAMS_FILE_TEMP_NAME, "w")
  if f == nil then
    print("Tried opening temporary StreamFile", e)
    IO_LOCK = false
    return false
  end

  local writeOk, writeResult = pcall(function()
    f:write(result):flush()
  end)
  f:close()

  if writeOk == false then
    print("Tried writing temporary StreamFile", writeResult)
    os.remove(STREAMS_FILE_TEMP_NAME)
    IO_LOCK = false
    return false
  end

  local hadOriginal = FileExists(STREAMS_FILE_NAME)
  if hadOriginal then
    os.remove(STREAMS_FILE_BACKUP_NAME)

    local backupOk, backupError = os.rename(STREAMS_FILE_NAME, STREAMS_FILE_BACKUP_NAME)
    if backupOk == nil then
      print("Tried backing up StreamFile", backupError)
      os.remove(STREAMS_FILE_TEMP_NAME)
      IO_LOCK = false
      return false
    end
  end

  local replaceOk, replaceError = os.rename(STREAMS_FILE_TEMP_NAME, STREAMS_FILE_NAME)
  if replaceOk == nil then
    print("Tried replacing StreamFile", replaceError)

    if hadOriginal then
      os.rename(STREAMS_FILE_BACKUP_NAME, STREAMS_FILE_NAME)
    end

    os.remove(STREAMS_FILE_TEMP_NAME)
    IO_LOCK = false
    return false
  end

  if hadOriginal then
    os.remove(STREAMS_FILE_BACKUP_NAME)
  end

  IO_LOCK = false
  return true
end
