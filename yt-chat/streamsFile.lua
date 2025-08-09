local json = require "libs/json"

require "constants"
require "mm2plHelper"
require "utils"

local STREAMS_FILE_NAME = "YT_CHAT.json"
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
  return json.decode(STREAMS_FILE_DEFAULT_CONTENT)
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
    return json.decode(rawFile)
  end

  return streamFile_create()
end

---@param data table
function StreamFile_Update(data)
  IO_LOCK = true

  local f, e = io.open(STREAMS_FILE_NAME, "w+")
  assert(f, e)

  f:seek("set", 0)

  f:write(json.encode(data)):flush()
  f:close()

  IO_LOCK = false
end
