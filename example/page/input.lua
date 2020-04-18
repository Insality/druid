local M = {}


function M.setup_page(self)
	self.druid:new_input("input_box_usual", "input_text_usual")
	self.druid:new_input("input_box_password", "input_text_password", gui.KEYBOARD_TYPE_PASSWORD)
	self.druid:new_input("input_box_email", "input_text_email", gui.KEYBOARD_TYPE_EMAIL)
	self.druid:new_input("input_box_numpad", "input_text_numpad", gui.KEYBOARD_TYPE_NUMBER_PAD)
		:set_allowed_characters("[%d,.]")
end


return M
