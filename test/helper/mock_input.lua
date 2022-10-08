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


function M.key_pressed(key_id)
	return hash(key_id), {
		pressed = true
	}
end


function M.key_released(key_id)
	return hash(key_id), {
		released = true
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


function M.input_empty_action_nil(x, y)
	return nil, {
		x = x,
		y = y,
	}
end



return M
