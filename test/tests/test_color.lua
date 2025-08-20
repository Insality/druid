return function()
	describe("Color Module", function()
		local color = nil

		before(function()
			color = require("druid.color")
		end)

		describe("Color Creation and Parsing", function()
			it("Should create colors from RGBA values", function()
				local test_color = color.new(1, 0.5, 0, 0.8)
				assert(test_color.x == 1)
				assert(test_color.y == 0.5)
				assert(test_color.z == 0)
				assert(test_color.w == 0.8)
			end)

			it("Should create colors from hex strings", function()
				local red = color.from_hex("#FF0000")
				assert(red.x == 1)
				assert(red.y == 0)
				assert(red.z == 0)
				assert(red.w == 1)

				local blue_with_alpha = color.from_hex("0000FF", 0.5)
				assert(blue_with_alpha.x == 0)
				assert(blue_with_alpha.y == 0)
				assert(blue_with_alpha.z == 1)
				assert(blue_with_alpha.w == 0.5)
			end)

			it("Should create colors from HSB values", function()
				local red = color.from_hsb(0, 1, 1) -- HSB for red
				assert(red.x == 1)
				assert(red.y == 0)
				assert(red.z == 0)
				assert(red.w == 1)
			end)

			it("Should parse various color formats", function()
				-- Test parsing alias for get_color
				local hex_color = color.parse("#FF0000")
				assert(hex_color.x == 1)

				local vector_color = color.parse(vmath.vector4(0, 1, 0, 1))
				assert(vector_color.y == 1)
			end)

			it("Should parse hex colors correctly with get_color", function()
				-- Test with # prefix
				local color1 = color.get_color("#FF0000")
				assert(color1.x == 1)
				assert(color1.y == 0)
				assert(color1.z == 0)
				assert(color1.w == 1)

				-- Test without # prefix
				local color2 = color.get_color("00FF00")
				assert(color2.x == 0)
				assert(color2.y == 1)
				assert(color2.z == 0)
				assert(color2.w == 1)

				-- Test 3-digit hex
				local color3 = color.get_color("F0F")
				assert(color3.x == 1)
				assert(color3.y == 0)
				assert(color3.z == 1)
				assert(color3.w == 1)
			end)

			it("Should handle vector4 input in get_color", function()
				local input_color = vmath.vector4(1, 0.5, 0, 1)
				local result = color.get_color(input_color)
				assert(result == input_color)
			end)

			it("Should return white for unknown color IDs", function()
				local result = color.get_color("unknown_color")
				assert(result.x == 1)
				assert(result.y == 1)
				assert(result.z == 1)
				assert(result.w == 1)
			end)
		end)

		describe("Color Format Conversion", function()
			it("Should convert colors to hex", function()
				local red = vmath.vector4(1, 0, 0, 1)
				local hex = color.to_hex(red)
				assert(hex == "FF0000")
			end)

			it("Should convert colors to RGB values", function()
				local test_color = vmath.vector4(1, 0.5, 0.25, 0.8)
				local r, g, b, a = color.to_rgb(test_color)
				assert(r == 1)
				assert(g == 0.5)
				assert(b == 0.25)
				assert(a == 0.8)
			end)

			it("Should convert colors to HSB values", function()
				local red = vmath.vector4(1, 0, 0, 1)
				local h, s, b, a = color.to_hsb(red)
				assert(h == 0) -- Red hue
				assert(s == 1) -- Full saturation
				assert(b == 1) -- Full brightness
				assert(a == 1) -- Full alpha
			end)

			it("Should convert hex to rgb values", function()
				local r, g, b = color.hex2rgb("#FF8000")
				assert(r == 1)
				assert(g == 0.5019607843137255) -- 128/255
				assert(b == 0)
			end)

			it("Should convert hex to vector4", function()
				local vec = color.hex2vector4("#FF8000", 0.5)
				assert(vec.x == 1)
				assert(vec.y == 0.5019607843137255)
				assert(vec.z == 0)
				assert(vec.w == 0.5)
			end)

			it("Should convert rgb to hex", function()
				local hex = color.rgb2hex(1, 0.5019607843137255, 0)
				assert(hex == "FF8000")
			end)
		end)

		describe("Color Space Conversion", function()
			it("Should convert RGB to HSB correctly", function()
				local h, s, v, a = color.rgb2hsb(1, 0, 0, 1) -- Red
				assert(h == 0)
				assert(s == 1)
				assert(v == 1)
				assert(a == 1)
			end)

			it("Should convert HSB to RGB correctly", function()
				local r, g, b, a = color.hsb2rgb(0, 1, 1, 1) -- Red
				assert(r == 1)
				assert(g == 0)
				assert(b == 0)
				assert(a == 1)
			end)

			it("Should handle round-trip HSB conversion", function()
				local original_r, original_g, original_b = 0.5, 0.7, 0.3
				local h, s, v = color.rgb2hsb(original_r, original_g, original_b)
				local converted_r, converted_g, converted_b = color.hsb2rgb(h, s, v)
				
				-- Allow for small floating point differences
				assert(math.abs(converted_r - original_r) < 0.001)
				assert(math.abs(converted_g - original_g) < 0.001)
				assert(math.abs(converted_b - original_b) < 0.001)
			end)
		end)

		describe("Palette Management", function()
			it("Should add and retrieve palette colors", function()
				local test_palette = {
					primary = vmath.vector4(1, 0, 0, 1),
					secondary = "#00FF00",
					tertiary = vmath.vector4(0, 0, 1, 1)
				}

				color.add_palette(test_palette)

				local primary = color.get_color("primary")
				assert(primary.x == 1)
				assert(primary.y == 0)
				assert(primary.z == 0)
				assert(primary.w == 1)

				local secondary = color.get_color("secondary")
				assert(secondary.x == 0)
				assert(secondary.y == 1)
				assert(secondary.z == 0)
				assert(secondary.w == 1)
			end)

			it("Should manage individual palette colors", function()
				-- Set a palette color
				color.set_palette_color("test_red", vmath.vector4(1, 0, 0, 1))
				assert(color.has_palette_color("test_red") == true)
				
				local retrieved = color.get_palette_color("test_red")
				assert(retrieved.x == 1)
				assert(retrieved.y == 0)
				assert(retrieved.z == 0)

				-- Remove the color
				color.remove_palette_color("test_red")
				assert(color.has_palette_color("test_red") == false)
				assert(color.get_palette_color("test_red") == nil)
			end)

			it("Should return the palette", function()
				local palette = color.get_palette()
				assert(type(palette) == "table")
			end)

			it("Should clear the palette", function()
				color.set_palette_color("temp_color", vmath.vector4(1, 1, 1, 1))
				color.clear_palette()
				assert(color.has_palette_color("temp_color") == false)
			end)
		end)

		describe("Color Manipulation", function()
			it("Should lerp colors correctly", function()
				local color1 = vmath.vector4(1, 0, 0, 1) -- Red
				local color2 = vmath.vector4(0, 1, 0, 1) -- Green
				
				local mid_color = color.lerp(0.5, color1, color2)
				-- Note: lerp uses HSB interpolation, so the result might not be a simple average
				assert(type(mid_color.x) == "number")
				assert(type(mid_color.y) == "number")
				assert(type(mid_color.z) == "number")
				assert(mid_color.w == 1)

				-- Test endpoints
				local start_color = color.lerp(0, color1, color2)
				local end_color = color.lerp(1, color1, color2)
				
				assert(math.abs(start_color.x - color1.x) < 0.001)
				assert(math.abs(end_color.x - color2.x) < 0.001)
			end)

			it("Should mix colors using linear RGB interpolation", function()
				local red = vmath.vector4(1, 0, 0, 1)
				local blue = vmath.vector4(0, 0, 1, 1)
				
				local mixed = color.mix(red, blue, 0.5)
				assert(mixed.x == 0.5) -- Half red
				assert(mixed.y == 0)   -- No green
				assert(mixed.z == 0.5) -- Half blue
				assert(mixed.w == 1)   -- Full alpha
			end)

			it("Should lighten colors", function()
				local dark_red = vmath.vector4(0.5, 0, 0, 1)
				local lightened = color.lighten(dark_red, 0.5)
				
				assert(lightened.x > dark_red.x) -- Should be lighter
				assert(lightened.y > dark_red.y) -- Should have some green/white
				assert(lightened.z > dark_red.z) -- Should have some blue/white
			end)

			it("Should darken colors", function()
				local bright_red = vmath.vector4(1, 0, 0, 1)
				local darkened = color.darken(bright_red, 0.5)
				
				assert(darkened.x < bright_red.x) -- Should be darker
				assert(darkened.y == 0) -- Should still have no green
				assert(darkened.z == 0) -- Should still have no blue
			end)

			it("Should adjust alpha", function()
				local opaque_red = vmath.vector4(1, 0, 0, 1)
				local semi_transparent = color.with_alpha(opaque_red, 0.5)
				
				assert(semi_transparent.x == 1) -- Color unchanged
				assert(semi_transparent.y == 0)
				assert(semi_transparent.z == 0)
				assert(semi_transparent.w == 0.5) -- Alpha changed
			end)
		end)

		describe("GUI Node Operations", function()
			it("Should set color on GUI node", function()
				-- Create a test node
				local test_node = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(100, 100, 0))
				
				-- Test with vector4
				local test_color = vmath.vector4(1, 0.5, 0, 1)
				color.set_color(test_node, test_color)
				
				-- Verify color was set (we can't easily read it back, but we can verify no errors)
				assert(true) -- If we get here, no error occurred

				-- Test with string color
				color.set_color(test_node, "#FF0000")
				assert(true) -- If we get here, no error occurred

				-- Clean up
				gui.delete_node(test_node)
			end)

			it("Should apply color to node using alias", function()
				local test_node = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(100, 100, 0))
				
				-- Test the alias function
				color.apply_to_node(test_node, vmath.vector4(0, 1, 0, 1))
				assert(true) -- If we get here, no error occurred

				gui.delete_node(test_node)
			end)

			it("Should set node color including alpha", function()
				local test_node = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(100, 100, 0))
				
				color.set_node_color_with_alpha(test_node, vmath.vector4(1, 0, 0, 0.5))
				assert(true) -- If we get here, no error occurred

				gui.delete_node(test_node)
			end)
		end)
	end)
end