--- Druid module with utils on string formats
-- @local
-- @module helper.formats

local const = require("druid.const")

local M = {}


--- Return number with zero number prefix
-- @function formats.add_prefix_zeros
-- @tparam number num Number for conversion
-- @tparam number count Count of numerals
-- @return string with need count of zero (1,3) -> 001
function M.add_prefix_zeros(num, count)
	local result = tostring(num)
	for i = string.len(result), count - 1 do
		result = const.ZERO .. result
	end
	return result
end


--- Convert seconds to string minutes:seconds
-- @function formats.second_string_min
-- @tparam number sec Seconds
-- @return string minutes:seconds
function M.second_string_min(sec)
	local mins = math.floor(sec / 60)
	local seconds = math.floor(sec - mins * 60)
	return string.format("%.2d:%.2d", mins, seconds)
end


--- Interpolate string with named Parameters in Table
-- @function formats.second_string_min
-- @tparam string s Target string
-- @tparam table tab Table with parameters
-- @return string with replaced parameters
function M.interpolate_string(s, tab)
	return (s:gsub('($%b{})', function(w) return tab[w:sub(3, -2)] or w end))
end


return M