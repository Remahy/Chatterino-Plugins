function Trim4(s)
  return s:match "^%s*(.*)":match "(.-)%s*$"
end
