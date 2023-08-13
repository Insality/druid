local druid = require("druid.druid")

local M = {}

local en = {
	ui_lang = "En",
	ui_current_lang = "Current lang: %s",
	main_page = "Main page",
	texts_page = "Text page",
	button_page = "Button page",
	scroll_page = "Scroll page",
	slider_page = "Slider page",
	input_page = "Input page",
	grid_page = "Grid page",
	infinity_page = "Infinity scroll",
	ui_section_button = "Button",
	ui_section_text = "Text",
	ui_section_timer = "Timer",
	ui_section_progress = "Progress",
	ui_section_slider = "Slider",
	ui_section_radio = "Radio",
	ui_section_checkbox = "Checkbox",
	ui_section_input = "Input",
	ui_text_example = "Translated",
	ui_text_change_lang = "Change lang",
	ui_example_1 = "Some text example",
	ui_example_2 = "Lang text with different length to be adjusted",
	ui_example_3 = "Text with 3 params: %s, %s and %s",
}

local ru = {
	ui_lang = "Ру",
	ui_current_lang = "Текущий язык: %s",
	main_page = "Основное",
	texts_page = "Текст",
	button_page = "Кнопки",
	scroll_page = "Скролл",
	slider_page = "Слайдеры",
	input_page = "Текст. ввод",
	grid_page = "Сетка",
	infinity_page = "Беск. скролл",
	ui_section_button = "Кнопка",
	ui_section_text = "Текст",
	ui_section_timer = "Таймер",
	ui_section_progress = "Прогресс",
	ui_section_slider = "Слайдер",
	ui_section_radio = "Выбор",
	ui_section_checkbox = "Мн. выбор",
	ui_section_input = "Ввод текста",
	ui_text_example = "Переведен",
	ui_text_change_lang = "Сменить язык",
	ui_example_1 = "Пример текста",
	ui_example_2 = "Короткий текст",
	ui_example_3 = "Текст с 3 параметрами: %s, %s и %s",
}


local data = en


function M.get_locale(lang_id, ...)
	local localized_text = data[lang_id] or lang_id

	if #{...} > 0 then
		localized_text = string.format(localized_text, ...)
	end

	return localized_text
end


function M.toggle_locale()
	data = data == en and ru or en
	druid.on_language_change()
end


return M
