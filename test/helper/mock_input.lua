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


function M.click_repeated(x, y)
	return hash("touch"), {
		repeated = true,
		x = x,
		y = y,
	}
end


function M.input_empty(x, y)
	return hash("touch"), {
		x = x,
		y = y,
	}
end


return M
