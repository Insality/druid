local M = {}

local ZERO = "0"

-- Return number with zero number prefix
-- @param num - number for conversion
-- @param count - count of numerals
-- @return string with need count of zero (1,3) -> 001
function M.add_prefix_zeros(num, count)
  local result = tostring(num)
  for i = string.len(result), count - 1 do
    result = ZERO..result
  end
  return result
end

-- Convert seconds to string minutes:seconds
-- @param num - number of seconds
-- @return string minutes:seconds
function M.second_string_min(sec)
  local mins = math.floor(sec / 60)
  local seconds = math.floor(sec - mins * 60)
  return string.format("%.2d:%.2d", mins, seconds)
end

-- Interpolate string with named Parameters in Table
-- @param s - string for interpolate
-- @param tab - table with parameters
-- @return string with replaced parameters
function M.interpolate_strinng(s, tab)
  return (s:gsub('($%b{})', function(w) return tab[w:sub(3, -2)] or w end))
end

return M
