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

function Parse_Timestamp(timestamp)
  local year, month, day, hour, min, sec = timestamp:match("(%d+)%-(%d+)%-(%d+)%s(%d+):(%d+):(%d+)")

  return {
    year = tonumber(year),
    month = tonumber(month),
    day = tonumber(day),
    hour = tonumber(hour),
    min = tonumber(min),
    sec = tonumber(sec)
  }
end

-- leap year check
local is_leap = function(year)
  return (year % 4 == 0 and year % 100 ~= 0) or (year % 400 == 0)
end

-- days in months (non-leap)
local mdays = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }

function To_Epoch(t)
  local year = t.year
  local month = t.month
  local day = t.day
  local hour = t.hour
  local min = t.min
  local sec = t.sec

  local days = 0

  -- add days for all previous years
  for y = 1970, year - 1 do
    days = days + (is_leap(y) and 366 or 365)
  end

  -- add days for months in this year
  for m = 1, month - 1 do
    days = days + mdays[m]
    if m == 2 and is_leap(year) then
      days = days + 1
    end
  end

  -- add days in current month
  days = days + (day - 1)

  return (days * 86400 + hour * 3600 + min * 60 + sec) * 1000
end
