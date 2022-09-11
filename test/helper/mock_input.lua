local M = {}


function M.click_pressed(x, y)
	return hash("touch"), {
		pressed = true,
		x = x,
		y = y,
	}
end


function M.click_released(x, y)
	return hash("touch"), {
		released = true,
		x = x,
		y = y,
	}
end


return M
