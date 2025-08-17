require "src/state/loadedChats"
require "src/parseLogs"
require "src/utils"

--- @param split c2.Channel
--- @param result c2.HTTPResponse
--- @param url string
--- @param options table
local initialize_logs = function(split, result, url, options)
  local logs = result:data()

  local data = options
  data.url = url

  -- [2025-05-03 11:31:26] #pajlada karar: ppHop
  -- [2025-05-03 11:31:50] #pajlada karar: ALLO CHA, ALLO PAJ
  data.data = String_Split(logs, "[^\r\n]+")
  -- { "[2025-05-03 11:31:26] #pajlada karar: ppHop", "[2025-05-03 11:31:50] #pajlada karar: ALLO CHA, ALLO PAJ" }

  -- TODO: Document the default "offline" functionality (We do one http request, and then browse the result.)
  -- Defining these two options will automatically make "next" & "prev" always do a http request.
  if OptionalChain(options, "limit") == nil and OptionalChain(options, "offset") == nil then
    data.o = 0
    data.offline = true
  end

  data.split = split

  Loaded_Chat_Set(split:get_name(), data)

  Parse_Logs(split)
end

---@param split c2.Channel
---@param url string
---@param options table
function Load_URL(split, url, options)
  local request = c2.HTTPRequest.create(c2.HTTPMethod.Get, url)
  Mutate_Request_Default_Headers(request)

  request:on_success(function(result) initialize_logs(split, result, url, options) end)

  request:on_error(function(result) print("Something went wrong reading url " .. url .. " : " .. result:error()) end)

  request:execute()
end
