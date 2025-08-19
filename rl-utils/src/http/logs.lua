require "src/state/loadedChats"
require "src/parseLogs"
require "src/utils"
require "src/systemMessages"

--- @param split c2.Channel
--- @param result c2.HTTPResponse
--- @param url string
--- @param command table
local initialize_logs = function(split, result, url, command)
  local logs = result:data()

  local splitData = command

  local options = splitData.options
  splitData.url = url

  print(url)

  -- [2025-05-03 11:31:26] #pajlada karar: ppHop
  -- [2025-05-03 11:31:50] #pajlada karar: ALLO CHA, ALLO PAJ
  splitData.data = String_Split(logs, "[^\r\n]+")
  -- { "[2025-05-03 11:31:26] #pajlada karar: ppHop", "[2025-05-03 11:31:50] #pajlada karar: ALLO CHA, ALLO PAJ" }

  -- TODO: Document the default "offline" functionality (We do one http request, and then browse the result.)
  -- Defining these two options will automatically make "next" & "prev" always do a http request.
  if OptionalChain(options, "limit") == nil and OptionalChain(options, "offset") == nil then
    splitData.o = OptionalChain(splitData, "o") or 0
    splitData.offline = true
  end

  splitData.split = split

  Loaded_Chat_Set(split:get_name(), splitData)

  Parse_Logs(split)
end

---@param split c2.Channel
---@param url string
---@param command table
function Load_URL(split, url, command)
  local request = c2.HTTPRequest.create(c2.HTTPMethod.Get, url)
  Mutate_Request_Default_Headers(request)

  request:on_success(function(result)
    initialize_logs(split, result, url, command)
  end)

  request:on_error(function(result)
    local e = result:error()
    print("Something went wrong reading url " .. url .. " : " .. e)
    Warn_HTTP_Error(split, url, e)
  end)

  request:execute()
end
