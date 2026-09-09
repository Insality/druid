return function()
	describe("Druid Component", function()
		local druid
		local druid_instance ---@type druid.instance
		local context
		local const = require("druid.const")
		local component = require("druid.component")

		before(function()
			context = vmath.vector3()
			druid = require("druid.druid")
			druid_instance = druid.new(context)
		end)

		after(function()
			-- Clean up druid instance
			if druid_instance then
				druid_instance:final()
				druid_instance = nil
			end
		end)

		-- The input priority is a plain component field, so the probe components without
		-- nodes are enough to check how the priority is spread over the components tree
		local child_class = component.create("test_priority_child")

		local parent_class = component.create("test_priority_parent")
		function parent_class:init()
			self.child = self:get_druid():new(child_class)
		end

		it("Should reset input priority to the component own default value", function()
			local parent = druid_instance:new(parent_class)
			local child = parent.child

			child:set_input_priority(const.PRIORITY_INPUT_MAX)
			assert(child:get_input_priority() == const.PRIORITY_INPUT_MAX)

			-- The temporary raise on the parent covers the whole subtree
			parent:set_input_priority(const.PRIORITY_INPUT_HIGH, true)
			assert(parent:get_input_priority() == const.PRIORITY_INPUT_HIGH)
			assert(child:get_input_priority() == const.PRIORITY_INPUT_HIGH)

			-- Consume the sort flags, the druid instance does it before the input processing
			parent:_reset_input_priority_changed()
			child:_reset_input_priority_changed()

			-- The child returns to it's own priority, not to the parent one
			parent:reset_input_priority()
			assert(parent:get_input_priority() == const.PRIORITY_INPUT)
			assert(child:get_input_priority() == const.PRIORITY_INPUT_MAX)
			assert(parent:_is_input_priority_changed() == true)
			assert(child:_is_input_priority_changed() == true)

			-- The child default value is not overriden by the parent reset
			child:set_input_priority(const.PRIORITY_INPUT_HIGH, true)
			child:reset_input_priority()
			assert(child:get_input_priority() == const.PRIORITY_INPUT_MAX)

			druid_instance:remove(parent)
		end)

		it("Should apply input priority to the subtree even if the value is the same", function()
			local parent = druid_instance:new(parent_class)
			local child = parent.child

			parent:set_input_priority(const.PRIORITY_INPUT_HIGH)
			assert(child:get_input_priority() == const.PRIORITY_INPUT_HIGH)

			-- The child priority is changed on it's own
			child:set_input_priority(const.PRIORITY_INPUT_MAX)

			-- The parent is already on this value, but the subtree should be synced anyway
			parent:set_input_priority(const.PRIORITY_INPUT_HIGH)
			assert(child:get_input_priority() == const.PRIORITY_INPUT_HIGH)

			-- The temporary raise keeps the default value
			parent:set_input_priority(const.PRIORITY_INPUT_MAX, true)
			assert(parent:get_input_priority() == const.PRIORITY_INPUT_MAX)

			-- The same value without the temporary flag makes it the new default one
			parent:set_input_priority(const.PRIORITY_INPUT_MAX)
			parent:reset_input_priority()
			assert(parent:get_input_priority() == const.PRIORITY_INPUT_MAX)

			druid_instance:remove(parent)
		end)
	end)
end
