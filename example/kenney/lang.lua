local M = {}

local data = {
	main_page = "Main page",
}


function M.get_locale(lang_id)
	return data[lang_id] or lang_id
end

return M