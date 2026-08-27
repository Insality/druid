return function()
	describe("Hotkey Component", function()
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

		it("Should trigger callback on single key release", function()
			local calls = 0
			local hotkey = druid:new_hotkey("key_a", function()
				calls = calls + 1
			end)

			druid:on_input(mock_input.key_pressed("key_a"))
			assert(calls == 0)

			druid:on_input(mock_input.key_released("key_a"))
			assert(calls == 1)
			assert(hotkey ~= nil)
		end)

		it("Should require modificator when configured", function()
			local calls = 0
			local hotkey = druid:new_hotkey({ "key_lctrl", "key_a" }, function()
				calls = calls + 1
			end)

			-- Without modificator pressed, key alone should not fire
			druid:on_input(mock_input.key_pressed("key_a"))
			druid:on_input(mock_input.key_released("key_a"))
			assert(calls == 0)

			-- With modificator
			druid:on_input(mock_input.key_pressed("key_lctrl"))
			druid:on_input(mock_input.key_pressed("key_a"))
			druid:on_input(mock_input.key_released("key_a"))
			assert(calls == 1)
			assert(hotkey ~= nil)
		end)

		it("Should not trigger plain hotkey while modificator is held", function()
			local calls = 0
			druid:new_hotkey("key_a", function()
				calls = calls + 1
			end)

			druid:on_input(mock_input.key_pressed("key_lctrl"))
			druid:on_input(mock_input.key_pressed("key_a"))
			druid:on_input(mock_input.key_released("key_a"))
			assert(calls == 0)
		end)
	end)
end
