return function()
	describe("Druid Input Filter", function()
		local druid
		local druid_instance ---@type druid.instance
		local context
		local mock_input = require("test.helper.mock_input")

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

		local component = require("druid.component")

		-- The input filter decides if the component receives on_input at all, so the probe
		-- component is enough to check it: no nodes, no clicks, no window geometry involved
		local probe_class = component.create("test_input_probe")
		function probe_class:init()
			self.input_calls = 0
		end
		function probe_class:on_input()
			self.input_calls = self.input_calls + 1
			return false
		end

		local function send_input()
			druid_instance:on_input(mock_input.click_pressed(0, 0))
		end

		-- Widget with two input probes, used to check the input filters scope
		local function create_test_widget()
			local widget_class = {}

			function widget_class:init()
				self.input_calls = 0
				self.probe_a = self.druid:new(probe_class)
				self.probe_b = self.druid:new(probe_class)
			end

			function widget_class:on_input()
				self.input_calls = self.input_calls + 1
				return false
			end

			return druid_instance:new_widget(widget_class)
		end

		it("Should clear input whitelist and blacklist with nil", function()
			local button_node = gui.new_box_node(vmath.vector3(50, 25, 0), vmath.vector3(100, 50, 0))
			local clicks = 0
			local button = druid_instance:new_button(button_node, function() clicks = clicks + 1 end)

			-- Placed away from the first button, so they never pick the same click
			local other_node = gui.new_box_node(vmath.vector3(250, 25, 0), vmath.vector3(100, 50, 0))
			local other = druid_instance:new_button(other_node, function() end)

			-- Whitelist the other button, so our button is filtered out
			druid_instance:set_whitelist({ other })
			druid_instance:on_input(mock_input.click_pressed(50, 25))
			druid_instance:on_input(mock_input.click_released(50, 25))
			assert(clicks == 0)

			-- Clearing must not error and must restore the unfiltered routing
			druid_instance:set_whitelist(nil)
			druid_instance:set_blacklist({ button })
			druid_instance:set_blacklist(nil)

			druid_instance:on_input(mock_input.click_pressed(50, 25))
			druid_instance:on_input(mock_input.click_released(50, 25))
			assert(clicks == 1)

			druid_instance:remove(button)
			druid_instance:remove(other)
			gui.delete_node(button_node)
			gui.delete_node(other_node)
		end)

		it("Should not modify the array passed to set_whitelist", function()
			local button_node = gui.new_box_node(vmath.vector3(50, 25, 0), vmath.vector3(100, 50, 0))
			local button = druid_instance:new_button(button_node, function() end)

			-- Button owns a hover child, it must not leak into the caller array
			local list = { button }
			druid_instance:set_whitelist(list)
			assert(#list == 1)

			druid_instance:set_blacklist(list)
			assert(#list == 1)

			druid_instance:set_whitelist(nil)
			druid_instance:set_blacklist(nil)
			druid_instance:remove(button)
			gui.delete_node(button_node)
		end)

		it("Should include children in whitelist and blacklist", function()
			local button_node = gui.new_box_node(vmath.vector3(50, 25, 0), vmath.vector3(100, 50, 0))
			local text_node = gui.new_text_node(vmath.vector3(50, 25, 0), "Text")
			gui.set_font(text_node, "druid_text_bold")

			-- Input owns a button child that handles the click to select
			local input = druid_instance:new_input(button_node, text_node)

			druid_instance:set_whitelist({ input })
			druid_instance:on_input(mock_input.click_pressed(50, 25))
			druid_instance:on_input(mock_input.click_released(50, 25))
			assert(input.is_selected == true)

			druid_instance:set_whitelist(nil)
			input:unselect()

			druid_instance:set_blacklist({ input })
			druid_instance:on_input(mock_input.click_pressed(50, 25))
			druid_instance:on_input(mock_input.click_released(50, 25))
			assert(input.is_selected == false)

			druid_instance:set_blacklist(nil)
			druid_instance:remove(input)
			gui.delete_node(button_node)
			gui.delete_node(text_node)
		end)

		it("Should apply the widget input filter to its subtree only", function()
			local widget = create_test_widget()
			local neighbor = create_test_widget()

			widget.druid:set_whitelist({ widget.probe_a })
			send_input()

			assert(widget.probe_a.input_calls == 1)
			assert(widget.probe_b.input_calls == 0)

			-- The neighbor widget shares the same Druid instance, but it is out of the filter scope
			assert(neighbor.probe_a.input_calls == 1)
			assert(neighbor.probe_b.input_calls == 1)

			-- The filter owner itself is not affected by its own filter
			assert(widget.input_calls == 1)

			druid_instance:remove(widget)
			druid_instance:remove(neighbor)
		end)

		it("Should not clear the instance input filter from the widget", function()
			local widget = create_test_widget()

			druid_instance:set_blacklist({ widget.probe_a })

			-- Clears the widget own filter, the instance one should be kept
			widget.druid:set_blacklist(nil)
			send_input()
			assert(widget.probe_a.input_calls == 0)

			druid_instance:set_blacklist(nil)
			send_input()
			assert(widget.probe_a.input_calls == 1)

			druid_instance:remove(widget)
		end)

		it("Should apply nested widget filters on top of the parent one", function()
			local child_class = {}
			function child_class:init()
				self.probe = self.druid:new(probe_class)
			end

			local parent_class = {}
			function parent_class:init()
				self.probe = self.druid:new(probe_class)
				self.child = self.druid:new_widget(child_class)
			end

			local parent = druid_instance:new_widget(parent_class)

			-- The nested widget is whitelisted, so its children pass by the parents chain
			parent.druid:set_whitelist({ parent.child })
			send_input()
			assert(parent.child.probe.input_calls == 1)
			assert(parent.probe.input_calls == 0)

			-- The nested widget filter is applied on top of the parent one
			parent.child.druid:set_blacklist({ parent.child.probe })
			send_input()
			assert(parent.child.probe.input_calls == 1)

			druid_instance:remove(parent)
		end)

		it("Should clear the widget input filter with nil", function()
			local widget = create_test_widget()

			widget.druid:set_whitelist({ widget.probe_a })
			widget.druid:set_blacklist({ widget.probe_a })
			send_input()
			assert(widget.probe_a.input_calls == 0)
			assert(widget.probe_b.input_calls == 0)

			widget.druid:set_whitelist(nil)
			widget.druid:set_blacklist(nil)
			send_input()
			assert(widget.probe_a.input_calls == 1)
			assert(widget.probe_b.input_calls == 1)

			druid_instance:remove(widget)
		end)

		it("Should keep the widget input filters independent from each other", function()
			local first = create_test_widget()
			local second = create_test_widget()

			first.druid:set_whitelist({ first.probe_a })
			second.druid:set_blacklist({ second.probe_a })
			send_input()

			assert(first.probe_a.input_calls == 1)
			assert(first.probe_b.input_calls == 0)
			assert(second.probe_a.input_calls == 0)
			assert(second.probe_b.input_calls == 1)

			-- Clearing the filter of one widget must not touch the other one
			first.druid:set_whitelist(nil)
			send_input()
			assert(first.probe_b.input_calls == 1)
			assert(second.probe_a.input_calls == 0)

			druid_instance:remove(first)
			druid_instance:remove(second)
		end)

		it("Should apply the instance input filter on top of the widget one", function()
			local widget = create_test_widget()

			-- The widget allows the first probe only, the instance blocks it
			widget.druid:set_whitelist({ widget.probe_a })
			druid_instance:set_blacklist({ widget.probe_a })
			send_input()
			assert(widget.probe_a.input_calls == 0)
			assert(widget.probe_b.input_calls == 0)

			druid_instance:set_blacklist(nil)
			send_input()
			assert(widget.probe_a.input_calls == 1)
			assert(widget.probe_b.input_calls == 0)

			druid_instance:remove(widget)
		end)

		it("Should apply both whitelist and blacklist of the same component", function()
			local widget = create_test_widget()

			widget.druid:set_whitelist({ widget.probe_a, widget.probe_b })
			widget.druid:set_blacklist({ widget.probe_b })
			send_input()

			assert(widget.probe_a.input_calls == 1)
			assert(widget.probe_b.input_calls == 0)

			druid_instance:remove(widget)
		end)

		it("Should block the whole subtree with the blacklist of the owner", function()
			local widget = create_test_widget()

			widget.druid:set_blacklist({ widget })
			send_input()

			assert(widget.probe_a.input_calls == 0)
			assert(widget.probe_b.input_calls == 0)

			-- The owner itself is not affected by its own filter
			assert(widget.input_calls == 1)

			druid_instance:remove(widget)
		end)

		it("Should apply the input filter set from the plain component", function()
			-- The plain component keeps the meta table as is, unlike the widget one
			local holder_class = component.create("test_input_filter")
			function holder_class:init()
				self.druid = self:get_druid()
				self.probe_a = self.druid:new(probe_class)
				self.probe_b = self.druid:new(probe_class)
			end

			local holder = druid_instance:new(holder_class)
			holder.druid:set_whitelist({ holder.probe_a })
			send_input()
			assert(holder.probe_a.input_calls == 1)
			assert(holder.probe_b.input_calls == 0)

			holder.druid:set_whitelist(nil)
			send_input()
			assert(holder.probe_b.input_calls == 1)

			druid_instance:remove(holder)
		end)
	end)
end
