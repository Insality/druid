local const = require("druid.const")

local M = {}

local en = {
	main_page = "Main page",
	ui_section_button = "Button",
	ui_section_text = "Text",
	ui_section_timer = "Timer",
	ui_section_progress = "Progress",
	ui_section_slider = "Slider",
	ui_section_radio = "Radio",
	ui_section_checkbox = "Checkbox",
	ui_text_example = "Translated",
}

local ru = {
	main_page = "Основное",
	ui_section_button = "Кнопка",
	ui_section_text = "Текст",
	ui_section_timer = "Таймер",
	ui_section_progress = "Прогресс",
	ui_section_slider = "Слайдер",
	ui_section_radio = "Выбор",
	ui_section_checkbox = "Мн. выбор",
	ui_text_example = "Переведен",
}


local data = en


function M.get_locale(lang_id)
	return data[lang_id] or lang_id
end


function M.toggle_locale()
	data = data == en and ru or en
	msg.post("/gui#main", const.ON_CHANGE_LANGUAGE)
end

return M