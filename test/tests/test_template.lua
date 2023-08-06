return function()
	local mock_gui = require "deftest.mock.gui"
	local mock_time = require("deftest.mock.time")
	local mock_input = require("test.helper.mock_input")
	local test_helper = require("test.helper.test_helper")
	local druid_system = require("druid.druid")

	local druid = nil
	local context = test_helper.get_context()
	describe("Template component", function()
		before(function()
			mock_gui.mock()
			mock_time.mock()
			mock_time.set(60)
			druid = druid_system.new(context)
		end)

		after(function()
			mock_gui.unmock()
			mock_time.unmock()
			druid:final(context)
			druid = nil
		end)

		it("Should do something right", function()
			assert(2 == 1 + 1)
		end)
	end)
end
