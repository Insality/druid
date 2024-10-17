return function()
	local mock_gui = nil
	local mock_time = nil
	local mock_input = nil
	local test_helper = nil
	local druid_system = nil

	local druid = nil
	local context = nil

	describe("Template component", function()
		before(function()
			mock_gui = require("deftest.mock.gui")
			mock_time = require("deftest.mock.time")
			mock_input = require("test.helper.mock_input")
			test_helper = require("test.helper.test_helper")
			druid_system = require("druid.druid")

			mock_gui.mock()
			mock_time.mock()
			mock_time.set(60)

			context = test_helper.get_context()
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
