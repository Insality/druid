--- Component for rich progress component
-- @module rich.progress_rich

local component = require("druid.system.component")

local M = component.new("progress_rich")


function M.init(self, name, red, green, key)
	self.druid = self:get_druid()
	self.style = self:get_style()
	self.red = self.druid:new_progress(red, key)
	self.green = self.druid:new_progress(green, key)
	self.fill = self.druid:new_progress(name, key)
end


--- Instant fill progress bar to value
-- @function progress_rich:set_to
-- @tparam table self Component instance
-- @tparam number value Progress bar value, from 0 to 1
function M.set_to(self, value)
	self.red:set_to(value)
	self.green:set_to(value)
	self.fill:set_to(value)
end


--- Empty a progress bar
-- @function progress_rich:empty
-- @tparam table self Component instance
function M.empty(self)
	self.red:empty()
	self.green:empty()
	self.fill:empty()
end


--- Start animation of a progress bar
-- @function progress_rich:to
-- @tparam table self Component instance
-- @tparam number to value between 0..1
-- @tparam[opt] function callback Callback on animation ends
function M.to(self, to, callback)
	if self.timer then
		timer.cancel(self.timer)
		self.timer = nil
	end

	if self.fill.last_value < to then
		self.red:to(self.fill.last_value)
		self.green:to(to, function()
			self.timer = timer.delay(self.style.DELAY, false, function()
				self.red:to(to)
				self.fill:to(to, callback)
			end)
		end)
	end

	if self.fill.last_value > to then
		self.green:to(self.red.last_value)
		self.fill:to(to, function()
			self.timer = timer.delay(self.style.DELAY, false, function()
				self.green:to(to)
				self.red:to(to, callback)
			end)
		end)
	end
end


return M
