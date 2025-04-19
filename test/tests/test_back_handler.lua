return function()
	describe("Back Handler component", function()
		local mock_time
		local mock_input
		local druid_system

		local druid
		local context

		before(function()
			mock_time = require("deftest.mock.time")
			mock_input = require("test.helper.mock_input")
			druid_system = require("druid.druid")

			mock_time.mock()
			mock_time.set(0)

			context = vmath.vector3()
			druid = druid_system.new(context)
		end)

		after(function()
			mock_time.unmock()
			druid:final()
			druid = nil
		end)

		it("Should react on back action id with custom args", function()
			local is_back_handler_called = false
			local context_arg = nil
			local back_handler_args = nil

			druid:new_back_handler(function(self, args)
				context_arg = self
				is_back_handler_called = true
				back_handler_args = args
			end, "custom")

			druid:on_input(mock_input.key_pressed("key_back"))
			druid:on_input(mock_input.key_released("key_back"))

			assert(is_back_handler_called)
			assert(back_handler_args == "custom")
			assert(context_arg == context)

			is_back_handler_called = false

			druid:on_input(mock_input.key_pressed("key_a"))
			druid:on_input(mock_input.key_released("key_a"))
			assert(is_back_handler_called == false)
		end)
	end)
end
