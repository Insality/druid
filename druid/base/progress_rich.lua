local M = {}

function M.init(instance, name, red, green, key)
	instance.red = instance.parent:new_progress(red, key)
	instance.green = instance.parent:new_progress(green, key)
	instance.fill = instance.parent:new_progress(name, key)
end


function M.set_to(instance, value)
	instance.red:set_to(value)
	instance.green:set_to(value)
	instance.fill:set_to(value)
end


function M.empty(instance)
	instance.red:empty()
	instance.green:empty()
	instance.fill:empty()
end


function M.to(instance, to, callback)
	if instance.fill.last_value < to then
		instance.green:to(to, function()
			instance.red:to(to)
			instance.fill:to(to, callback)
		end)
	end

	if instance.fill.last_value > to then
		instance.fill:to(to, function()
			instance.green:to(to)
			instance.red:to(to, callback)
		end)
	end
end


return M