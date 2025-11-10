return function()
    describe("Rich Text Component", function()
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


        it("Should initialize with default settings", function()
            local text_node = gui.new_text_node(vmath.vector3(50, 50, 0), "Initial Text")
            gui.set_font(text_node, "druid_text_bold")

            local rich_text = druid:new_rich_text(text_node)

            assert(rich_text ~= nil)
            assert(rich_text.root == text_node)
            assert(rich_text.text_prefab == text_node)
            assert(rich_text:get_text() == "Initial Text")

            -- Check that the original text node is cleared
            assert(gui.get_text(text_node) == "")

            druid:remove(rich_text)
            gui.delete_node(text_node)
        end)

        it("Should initialize with custom text", function()
            local text_node = gui.new_text_node(vmath.vector3(50, 50, 0), "Initial Text")
            gui.set_font(text_node, "druid_text_bold")

            local rich_text = druid:new_rich_text(text_node, "Custom Text")

            assert(rich_text:get_text() == "Custom Text")

            druid:remove(rich_text)
            gui.delete_node(text_node)
        end)

        it("Should handle basic text setting and getting", function()
            local text_node = gui.new_text_node(vmath.vector3(50, 50, 0), "")
            gui.set_font(text_node, "druid_text_bold")

            local rich_text = druid:new_rich_text(text_node)

            assert(rich_text:get_text() == "")

            rich_text:set_text("Hello, World!")
            assert(rich_text:get_text() == "Hello, World!")

            rich_text:set_text("New text")
            assert(rich_text:get_text() == "New text")

            druid:remove(rich_text)
            gui.delete_node(text_node)
        end)

        it("Should handle color tag", function()
            local text_node = gui.new_text_node(vmath.vector3(50, 50, 0), "")
            gui.set_font(text_node, "druid_text_bold")

            local rich_text = druid:new_rich_text(text_node)

            -- Test color tag with named color
            local words = rich_text:set_text("<color=#FF0000>Colored Text</color>")

            assert(#words > 0)
            -- Word should have a tags field with color tag
            assert(words[1].tags.color)

            -- Test color tag with RGB values
            words = rich_text:set_text("<color=1.0,0,0,1.0>Colored Text</color>")

            assert(#words > 0)
            assert(words[1].tags.color)

            druid:remove(rich_text)
            gui.delete_node(text_node)
        end)

        it("Should handle shadow tag", function()
            local text_node = gui.new_text_node(vmath.vector3(50, 50, 0), "")
            gui.set_font(text_node, "druid_text_bold")

            local rich_text = druid:new_rich_text(text_node)

            -- Test shadow tag with named color
            local words = rich_text:set_text("<shadow=#000000>Shadowed Text</shadow>")

            assert(#words > 0)
            assert(words[1].shadow ~= nil)
            assert(words[1].shadow.x < 0.1) -- Black shadow should have low RGB values
            assert(words[1].shadow.y < 0.1)
            assert(words[1].shadow.z < 0.1)

            druid:remove(rich_text)
            gui.delete_node(text_node)
        end)

        it("Should handle outline tag", function()
            local text_node = gui.new_text_node(vmath.vector3(50, 50, 0), "")
            gui.set_font(text_node, "druid_text_bold")

            local rich_text = druid:new_rich_text(text_node)

            -- Test outline tag with named color
            local words = rich_text:set_text("<outline=#000000>Outlined Text</outline>")

            assert(#words > 0)
            assert(words[1].outline ~= nil)
            assert(words[1].outline.x < 0.1) -- Black outline should have low RGB values
            assert(words[1].outline.y < 0.1)
            assert(words[1].outline.z < 0.1)

            druid:remove(rich_text)
            gui.delete_node(text_node)
        end)

        it("Should handle size tag", function()
            local text_node = gui.new_text_node(vmath.vector3(50, 50, 0), "")
            gui.set_font(text_node, "druid_text_bold")

            local rich_text = druid:new_rich_text(text_node)

            -- Test size tag with value of 2 (twice as large)
            local words = rich_text:set_text("<size=2>Large Text</size>")

            assert(#words > 0)
            assert(words[1].relative_scale == 2)

            -- Test size tag with value of 0.5 (half as large)
            words = rich_text:set_text("<size=0.5>Small Text</size>")

            assert(#words > 0)
            assert(words[1].relative_scale == 0.5)

            druid:remove(rich_text)
            gui.delete_node(text_node)
        end)

        it("Should handle line break tag", function()
            local text_node = gui.new_text_node(vmath.vector3(50, 50, 0), "")
            gui.set_font(text_node, "druid_text_bold")
            gui.set_line_break(text_node, true) -- Enable multiline

            local rich_text = druid:new_rich_text(text_node)

            -- Test line break tag
            local words, line_metrics = rich_text:set_text("Line 1<br/>Line 2")

            assert(#words > 0)
            assert(line_metrics.lines ~= nil)
            assert(#line_metrics.lines >= 2) -- Should have at least 2 lines

            druid:remove(rich_text)
            gui.delete_node(text_node)
        end)

        it("Should handle nobr tag", function()
            local text_node = gui.new_text_node(vmath.vector3(50, 50, 0), "")
            gui.set_font(text_node, "druid_text_bold")
            gui.set_line_break(text_node, true) -- Enable multiline

            local rich_text = druid:new_rich_text(text_node)

            -- Test no break tag
            local words = rich_text:set_text("<nobr>This text should not break to multiple lines</nobr>")

            assert(#words > 0)
            assert(words[1].nobr == true)

            druid:remove(rich_text)
            gui.delete_node(text_node)
        end)

        it("Should handle image tag", function()
            local text_node = gui.new_text_node(vmath.vector3(50, 50, 0), "")
            gui.set_font(text_node, "druid_text_bold")

            local rich_text = druid:new_rich_text(text_node)

            -- Testing with a default texture with a fixed width and height to avoid nil errors
            -- (This ensures image.width and image.height are numbers, not nil)
            local words = rich_text:set_text("<img=druid:pixel,50,50/>")

            assert(#words > 0)
            assert(words[1].tags.img)

            druid:remove(rich_text)
            gui.delete_node(text_node)
        end)

        it("Should handle multiple tags", function()
            local text_node = gui.new_text_node(vmath.vector3(50, 50, 0), "")
            gui.set_font(text_node, "druid_text_bold")

            local rich_text = druid:new_rich_text(text_node)

            -- Test combined tags
            local words = rich_text:set_text("<color=#FF0000><size=2>Big Red Text</size></color>")

            assert(#words > 0)
            assert(words[1].tags.color)
            assert(words[1].tags.size)
            assert(words[1].relative_scale == 2)

            -- Test nested tags
            words = rich_text:set_text("<color=#FF0000>Red <size=2>Big Red</size> Red</color>")

            assert(#words >= 3)
            -- All words should have color tag
            assert(words[1].tags.color)
            assert(words[2].tags.color)
            assert(words[3].tags.color)

            -- Middle word should also have size tag
            assert(words[2].tags.size)
            assert(words[2].relative_scale == 2)

            druid:remove(rich_text)
            gui.delete_node(text_node)
        end)

        it("Should handle tagged words", function()
            local text_node = gui.new_text_node(vmath.vector3(50, 50, 0), "")
            gui.set_font(text_node, "druid_text_bold")

            local rich_text = druid:new_rich_text(text_node)

            -- Set text with a custom tag
            rich_text:set_text("<mytag>Tagged Text</mytag> Normal Text")

            -- Get words with the custom tag
            local tagged_words = rich_text:tagged("mytag")

            assert(#tagged_words > 0)
            assert(tagged_words[1].tags.mytag == true)

            druid:remove(rich_text)
            gui.delete_node(text_node)
        end)

        it("Should clear text", function()
            local text_node = gui.new_text_node(vmath.vector3(50, 50, 0), "")
            gui.set_font(text_node, "druid_text_bold")

            local rich_text = druid:new_rich_text(text_node)

            -- Set some text first
            rich_text:set_text("Hello, World!")

            assert(rich_text:get_text() == "Hello, World!")
            assert(rich_text:get_words() ~= nil)

            -- Clear text
            rich_text:clear()

            assert(rich_text:get_text() == nil)
            assert(rich_text:get_words() == nil)

            druid:remove(rich_text)
            gui.delete_node(text_node)
        end)

        it("Should get words and line metrics", function()
            local text_node = gui.new_text_node(vmath.vector3(50, 50, 0), "")
            gui.set_font(text_node, "druid_text_bold")

            local rich_text = druid:new_rich_text(text_node)

            -- Set text
            rich_text:set_text("Hello, World!")

            -- Get words
            local words = rich_text:get_words()

            assert(words ~= nil)
            assert(#words > 0)

            -- Get line metrics
            local line_metrics = rich_text:get_line_metric()

            assert(line_metrics ~= nil)
            -- Just check line_metrics exists, don't assume values
            assert(line_metrics.lines ~= nil)

            druid:remove(rich_text)
            gui.delete_node(text_node)
        end)
    end)
end
