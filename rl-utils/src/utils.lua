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
