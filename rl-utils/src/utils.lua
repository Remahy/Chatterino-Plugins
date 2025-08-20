---@param request c2.HTTPRequest
function Mutate_Request_Default_Headers(request)
  request:set_header("User-Agent", "remahy/chatterino_plugins/rl_utils")
  request:set_header("Accept-Language", "en")
end

function FileExists(filename)
  local isPresent = nil
  local f = io.open(filename, "r")

  if f then
    isPresent = true
    f:close()
  end

  return isPresent
end

-- http://lua-users.org/wiki/SplitJoin
function String_Split(str, pat)
  local tbl = {}
  str:gsub(pat, function(x) tbl[#tbl + 1] = x end)
  return tbl
end

--- https://github.com/idbrii/lua-lume/blob/master/lume.lua
--- Returns the index/key of `value` in `t`. Returns `nil` if that value does not
-- exist in the table.
function LumeFind(t, value)
  for k, v in ipairs(t) do
    if v == value then return k end
  end
  return nil
end

function Ternary(condition, whenTrue, whenFalse)
  if condition then
    return whenTrue
  end

  return whenFalse
end
