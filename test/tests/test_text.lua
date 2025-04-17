return function()
    describe("Text Component", function()
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

        it("Should create text component and set text", function()
            local text_node = gui.new_text_node(vmath.vector3(50, 25, 0), "Initial Text")
            gui.set_font(text_node, "druid_text_bold")

            local text = druid:new_text(text_node, "New Text")

            assert(text ~= nil)
            assert(text.node == text_node)
            assert(gui.get_text(text_node) == "New Text")
            assert(text:get_text() == "New Text")

            -- Test that text setter works
            text:set_text("Updated Text")
            assert(gui.get_text(text_node) == "Updated Text")
            assert(text:get_text() == "Updated Text")

            druid:remove(text)
            gui.delete_node(text_node)
        end)

        it("Should fire on_set_text event", function()
            local text_node = gui.new_text_node(vmath.vector3(50, 25, 0), "Initial Text")
            gui.set_font(text_node, "druid_text_bold")

            local text = druid:new_text(text_node)

            local on_set_text_calls = 0
            local last_text = nil

            text.on_set_text:subscribe(function(_, new_text)
                on_set_text_calls = on_set_text_calls + 1
                last_text = new_text
            end)

            text:set_text("Event Test")

            assert(on_set_text_calls == 1)
            assert(last_text == "Event Test")

            druid:remove(text)
            gui.delete_node(text_node)
        end)

        it("Should change color and alpha", function()
            local text_node = gui.new_text_node(vmath.vector3(50, 25, 0), "Color Test")
            gui.set_font(text_node, "druid_text_bold")

            local text = druid:new_text(text_node)

            local initial_color = gui.get_color(text_node)
            local new_color = vmath.vector4(1, 0, 0, 1)

            text:set_color(new_color)
            assert(gui.get_color(text_node).x == new_color.x)
            assert(gui.get_color(text_node).y == new_color.y)
            assert(gui.get_color(text_node).z == new_color.z)

            text:set_alpha(0.5)
            assert(gui.get_color(text_node).w == 0.5)

            druid:remove(text)
            gui.delete_node(text_node)
        end)

        it("Should set scale", function()
            local text_node = gui.new_text_node(vmath.vector3(50, 25, 0), "Scale Test")
            gui.set_font(text_node, "druid_text_bold")

            local text = druid:new_text(text_node)

            local new_scale = vmath.vector3(2, 2, 1)
            text:set_scale(new_scale)

            local current_scale = gui.get_scale(text_node)
            assert(current_scale.x == new_scale.x)
            assert(current_scale.y == new_scale.y)

            druid:remove(text)
            gui.delete_node(text_node)
        end)

        it("Should set pivot and fire event", function()
            local text_node = gui.new_text_node(vmath.vector3(50, 25, 0), "Pivot Test")
            gui.set_font(text_node, "druid_text_bold")

            local text = druid:new_text(text_node)

            local on_set_pivot_calls = 0
            local last_pivot = nil

            text.on_set_pivot:subscribe(function(_, pivot)
                on_set_pivot_calls = on_set_pivot_calls + 1
                last_pivot = pivot
            end)

            text:set_pivot(gui.PIVOT_CENTER)

            assert(on_set_pivot_calls == 1)
            assert(last_pivot == gui.PIVOT_CENTER)
            assert(gui.get_pivot(text_node) == gui.PIVOT_CENTER)

            druid:remove(text)
            gui.delete_node(text_node)
        end)

        it("Should set text size", function()
            local text_node = gui.new_text_node(vmath.vector3(50, 25, 0), "Size Test")
            gui.set_font(text_node, "druid_text_bold")

            local text = druid:new_text(text_node)

            local initial_size = gui.get_size(text_node)
            local new_size = vmath.vector3(200, 100, 0)

            text:set_size(new_size)

            -- Since setting size triggers adjust mechanisms, we can't directly check node size
            -- but we can check that the internal size was updated
            assert(text.start_size.x == new_size.x)
            assert(text.start_size.y == new_size.y)

            druid:remove(text)
            gui.delete_node(text_node)
        end)

        it("Should handle different adjust types", function()
            local text_node = gui.new_text_node(vmath.vector3(50, 25, 0), "Adjust Test")
            gui.set_font(text_node, "druid_text_bold")
            gui.set_size(text_node, vmath.vector3(100, 50, 0))

            local text = druid:new_text(text_node, "This is a very long text that should be adjusted")

            -- Test default adjust (downscale)
            local initial_adjust = text:get_text_adjust()
            assert(initial_adjust == "downscale")

            -- Test no_adjust
            text:set_text_adjust("no_adjust")
            assert(text:get_text_adjust() == "no_adjust")

            -- Test trim
            text:set_text_adjust("trim")
            assert(text:get_text_adjust() == "trim")

            -- Test with minimal scale
            text:set_text_adjust("downscale_limited", 0.5)
            assert(text:get_text_adjust() == "downscale_limited")

            druid:remove(text)
            gui.delete_node(text_node)
        end)

        it("Should get text size", function()
            local text_node = gui.new_text_node(vmath.vector3(50, 25, 0), "Text Size Test")
            gui.set_font(text_node, "druid_text_bold")

            local text = druid:new_text(text_node)

            local width, height = text:get_text_size()

            assert(width > 0)
            assert(height > 0)

            druid:remove(text)
            gui.delete_node(text_node)
        end)

        it("Should check if text is multiline", function()
            local text_node = gui.new_text_node(vmath.vector3(50, 25, 0), "Single line")
            gui.set_font(text_node, "druid_text_bold")
            gui.set_line_break(text_node, false)

            local text = druid:new_text(text_node)

            assert(text:is_multiline() == false)

            -- Change to multiline
            gui.set_line_break(text_node, true)

            assert(text:is_multiline() == true)

            druid:remove(text)
            gui.delete_node(text_node)
        end)

        it("Should fire on_update_text_scale event", function()
            local text_node = gui.new_text_node(vmath.vector3(50, 25, 0), "Scale Event Test")
            gui.set_font(text_node, "druid_text_bold")
            gui.set_size(text_node, vmath.vector3(100, 50, 0))

            local text = druid:new_text(text_node)

            local on_update_text_scale_calls = 0
            local last_scale = nil

            text.on_update_text_scale:subscribe(function(_, scale)
                on_update_text_scale_calls = on_update_text_scale_calls + 1
                last_scale = scale
            end)

            -- Trigger scale update
            text:set_text("This text is long enough to trigger scaling")

            assert(on_update_text_scale_calls >= 1)
            assert(last_scale ~= nil)

            druid:remove(text)
            gui.delete_node(text_node)
        end)
    end)
end
