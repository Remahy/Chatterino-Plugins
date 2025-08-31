-- http://lua-users.org/wiki/SplitJoin
function String_Split(str, pat)
  local tbl = {}
  str:gsub(pat, function(x) tbl[#tbl + 1] = x end)
  return tbl
end
