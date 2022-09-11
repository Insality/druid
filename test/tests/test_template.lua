local mock_gui = require "deftest.mock.gui"

return function()
	describe("Eva lang", function()
		before(function()
			mock_gui.mock()
		end)

		after(function()
			mock_gui.unmock()
		end)

		it("Should do something right", function()
			assert(2 == 1 + 1)
		end)
	end)
end
