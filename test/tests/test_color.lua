local function is_equal(a, b, epsilon)
	epsilon = epsilon or 0.01
	return math.abs(a - b) < epsilon
end

return function()
	describe("Color Module", function()
		local color = nil ---@type druid.color

		before(function()
			color = require("druid.color")
		end)

		after(function()
			-- Clear palette after each test to avoid state leakage
			local palette = color.get_palette()
			for k in pairs(palette) do
				palette[k] = nil
			end
		end)

		describe("get_color", function()
			it("Should return vector4 as-is", function()
				local vec4 = vmath.vector4(0.5, 0.6, 0.7, 0.8)
				local result = color.get_color(vec4)

				-- With rounding errors
				assert(is_equal(result.x, 0.5))
				assert(is_equal(result.y, 0.6))
				assert(is_equal(result.z, 0.7))
				assert(is_equal(result.w, 0.8))

				assert(types.is_vector4(result))
			end)

			it("Should return vector3 as-is", function()
				local vec3 = vmath.vector3(0.5, 0.6, 0.7)
				local result = color.get_color(vec3)
				-- With rounding errors
				assert(is_equal(result.x, 0.5))
				assert(is_equal(result.y, 0.6))
				assert(is_equal(result.z, 0.7))

				assert(types.is_vector3(result))
			end)

			it("Should get color from palette", function()
				color.add_palette({
					test_red = vmath.vector4(1, 0, 0, 1),
					test_green = "#00FF00"
				})

				local red = color.get_color("test_red")
				assert(red.x == 1)
				assert(red.y == 0)
				assert(red.z == 0)
				assert(red.w == 1)

				local green = color.get_color("test_green")
				assert(green.x == 0)
				assert(green.y == 1)
				assert(green.z == 0)
			end)

			it("Should convert hex string with # prefix", function()
				local result = color.get_color("#FF0000")
				assert(result.x == 1)
				assert(result.y == 0)
				assert(result.z == 0)
				assert(result.w == 1)
			end)

			it("Should convert hex string without # prefix", function()
				local result = color.get_color("00FF00")
				assert(result.x == 0)
				assert(result.y == 1)
				assert(result.z == 0)
			end)

			it("Should convert 3-digit hex string", function()
				local result = color.get_color("#F00")
				assert(result.x == 1)
				assert(result.y == 0)
				assert(result.z == 0)
			end)

			it("Should return white for invalid color ID", function()
				local result = color.get_color("nonexistent_color")
				assert(result.x == 1)
				assert(result.y == 1)
				assert(result.z == 1)
				assert(result.w == 1)
			end)
		end)

		describe("add_palette", function()
			it("Should add vector4 colors to palette", function()
				color.add_palette({
					blue = vmath.vector4(0, 0, 1, 1),
					yellow = vmath.vector4(1, 1, 0, 1)
				})

				local palette = color.get_palette()
				assert(palette.blue.x == 0)
				assert(palette.blue.y == 0)
				assert(palette.blue.z == 1)
				assert(palette.yellow.x == 1)
				assert(palette.yellow.y == 1)
				assert(palette.yellow.z == 0)
			end)

			it("Should add hex string colors to palette", function()
				color.add_palette({
					cyan = "#00FFFF",
					magenta = "FF00FF"
				})

				local palette = color.get_palette()
				assert(palette.cyan.x == 0)
				assert(palette.cyan.y == 1)
				assert(palette.cyan.z == 1)
				assert(palette.magenta.x == 1)
				assert(palette.magenta.y == 0)
				assert(palette.magenta.z == 1)
			end)

			it("Should merge with existing palette", function()
				color.add_palette({ color1 = vmath.vector4(1, 0, 0, 1) })
				color.add_palette({ color2 = vmath.vector4(0, 1, 0, 1) })

				local palette = color.get_palette()
				assert(palette.color1 ~= nil)
				assert(palette.color2 ~= nil)
			end)
		end)

		describe("get_palette", function()
			it("Should return empty palette initially", function()
				local palette = color.get_palette()
				local count = 0
				for _ in pairs(palette) do
					count = count + 1
				end
				assert(count == 0)
			end)

			it("Should return all palette colors", function()
				color.add_palette({
					red = vmath.vector4(1, 0, 0, 1),
					green = vmath.vector4(0, 1, 0, 1),
					blue = vmath.vector4(0, 0, 1, 1)
				})

				local palette = color.get_palette()
				assert(palette.red ~= nil)
				assert(palette.green ~= nil)
				assert(palette.blue ~= nil)
			end)
		end)

		describe("set_color", function()
			it("Should set color from vector4", function()
				local mock_node = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(100, 100, 0))
				local test_color = vmath.vector4(0.5, 0.6, 0.7, 0.8)

				color.set_color(mock_node, test_color)

				local node_color = gui.get_color(mock_node)
				-- With rounding errors
				assert(is_equal(node_color.x, 0.5))
				assert(is_equal(node_color.y, 0.6))
				assert(is_equal(node_color.z, 0.7))
				-- set_color does not change alpha, so it remains at default (1.0)
				assert(is_equal(node_color.w, 1))

				gui.delete_node(mock_node)
			end)

			it("Should set color from vector3", function()
				local mock_node = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(100, 100, 0))
				local test_color = vmath.vector3(0.2, 0.3, 0.4)

				color.set_color(mock_node, test_color)

				local node_color = gui.get_color(mock_node)
				-- With rounding errors
				assert(is_equal(node_color.x, 0.2))
				assert(is_equal(node_color.y, 0.3))
				assert(is_equal(node_color.z, 0.4))

				gui.delete_node(mock_node)
			end)

			it("Should set color from string palette ID", function()
				local mock_node = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(100, 100, 0))
				color.add_palette({ test_color = vmath.vector4(0.9, 0.1, 0.2, 1) })

				color.set_color(mock_node, "test_color")

				local node_color = gui.get_color(mock_node)
				-- With rounding errors
				assert(is_equal(node_color.x, 0.9))
				assert(is_equal(node_color.y, 0.1))
				assert(is_equal(node_color.z, 0.2))

				gui.delete_node(mock_node)
			end)

			it("Should set color from hex string", function()
				local mock_node = gui.new_box_node(vmath.vector3(0, 0, 0), vmath.vector3(100, 100, 0))

				color.set_color(mock_node, "#FF0000")

				local node_color = gui.get_color(mock_node)
				-- With rounding errors
				assert(is_equal(node_color.x, 1))
				assert(is_equal(node_color.y, 0))
				assert(is_equal(node_color.z, 0))

				gui.delete_node(mock_node)
			end)
		end)

		describe("lerp", function()
			it("Should return first color at t=0", function()
				local color1 = vmath.vector4(1, 0, 0, 1)
				local color2 = vmath.vector4(0, 1, 0, 1)
				local result = color.lerp(0, color1, color2)

				assert(is_equal(result.x, 1))
				assert(is_equal(result.y, 0))
				assert(is_equal(result.z, 0))
			end)

			it("Should return second color at t=1", function()
				local color1 = vmath.vector4(1, 0, 0, 1)
				local color2 = vmath.vector4(0, 1, 0, 1)
				local result = color.lerp(1, color1, color2)

				assert(is_equal(result.x, 0))
				assert(is_equal(result.y, 1))
				assert(is_equal(result.z, 0))
			end)

			it("Should interpolate with different t values", function()
				local color1 = color.get_color("#FF0000")
				local color2 = color.get_color("#00FF00")

				local result = color.lerp(0.5, color1, color2)
				assert(is_equal(result.x, 1))
				assert(is_equal(result.y, 1))
				assert(is_equal(result.z, 0))

				local result2 = color.lerp(0.75, color2, color1)
				assert(is_equal(result2.x, 1))
				assert(is_equal(result2.y, 0.5))
				assert(is_equal(result2.z, 0))

				local result3 = color.lerp(0.25, color1, color2)
				assert(is_equal(result3.x, 1))
				assert(is_equal(result3.y, 0.5))
				assert(is_equal(result3.z, 0))

				local result4 = color.lerp(0.25, color1, color2)
				print(result4.x, result4.y, result4.z)
				assert(is_equal(result4.x, 1))
				assert(is_equal(result4.y, 0.5))
				assert(is_equal(result4.z, 0))
			end)

			it("Should preserve alpha", function()
				local color1 = vmath.vector4(1, 0, 0, 0.5)
				local color2 = vmath.vector4(0, 1, 0, 0.8)
				local result = color.lerp(0.5, color1, color2)

				-- lerp function interpolates alpha between the two colors
				assert(result.w > 0.5 and result.w < 0.8)
				assert(is_equal(result.w, 0.65))
			end)
		end)

		describe("hex2rgb", function()
			it("Should convert 6-digit hex with #", function()
				local r, g, b = color.hex2rgb("#FF0000")
				assert(r == 1)
				assert(g == 0)
				assert(b == 0)
			end)

			it("Should convert 6-digit hex without #", function()
				local r, g, b = color.hex2rgb("00FF00")
				assert(r == 0)
				assert(g == 1)
				assert(b == 0)
			end)

			it("Should convert 3-digit hex", function()
				local r, g, b = color.hex2rgb("#F00")
				assert(r == 1)
				assert(g == 0)
				assert(b == 0)
			end)

			it("Should convert 3-digit hex without #", function()
				local r, g, b = color.hex2rgb("0F0")
				assert(r == 0)
				assert(g == 1)
				assert(b == 0)
			end)

			it("Should handle lowercase hex", function()
				local r, g, b = color.hex2rgb("#ff00ff")
				assert(r == 1)
				assert(g == 0)
				assert(b == 1)
			end)

			it("Should return black for invalid input", function()
				local r, g, b = color.hex2rgb("")
				assert(r == 0)
				assert(g == 0)
				assert(b == 0)
			end)

			it("Should return black for nil input", function()
				local r, g, b = color.hex2rgb(nil)
				assert(r == 0)
				assert(g == 0)
				assert(b == 0)
			end)
		end)

		describe("hex2vector4", function()
			it("Should convert hex to vector4 with default alpha", function()
				local result = color.hex2vector4("#FF0000")
				assert(result.x == 1)
				assert(result.y == 0)
				assert(result.z == 0)
				assert(result.w == 1)
			end)

			it("Should convert hex to vector4 with custom alpha", function()
				local result = color.hex2vector4("#00FF00", 0.5)
				assert(result.x == 0)
				assert(result.y == 1)
				assert(result.z == 0)
				assert(result.w == 0.5)
			end)

			it("Should handle 3-digit hex", function()
				local result = color.hex2vector4("#F0F")
				assert(result.x == 1)
				assert(result.y == 0)
				assert(result.z == 1)
			end)
		end)

		describe("rgb2hsb", function()
			it("Should convert red to HSB", function()
				local h, s, v, a = color.rgb2hsb(1, 0, 0)
				assert(math.abs(h - 0) < 0.01 or math.abs(h - 1) < 0.01)
				assert(s == 1)
				assert(v == 1)
				assert(a == 1)
			end)

			it("Should convert green to HSB", function()
				local h, s, v, a = color.rgb2hsb(0, 1, 0)
				assert(math.abs(h - 1/3) < 0.01)
				assert(s == 1)
				assert(v == 1)
			end)

			it("Should convert blue to HSB", function()
				local h, s, v, a = color.rgb2hsb(0, 0, 1)
				assert(math.abs(h - 2/3) < 0.01)
				assert(s == 1)
				assert(v == 1)
			end)

			it("Should convert white to HSB", function()
				local h, s, v, a = color.rgb2hsb(1, 1, 1)
				assert(s == 0)
				assert(v == 1)
			end)

			it("Should convert black to HSB", function()
				local h, s, v, a = color.rgb2hsb(0, 0, 0)
				assert(s == 0)
				assert(v == 0)
			end)

			it("Should handle custom alpha", function()
				local h, s, v, a = color.rgb2hsb(1, 0, 0, 0.5)
				assert(a == 0.5)
			end)
		end)

		describe("hsb2rgb", function()
			it("Should convert red HSB to RGB", function()
				local r, g, b, a = color.hsb2rgb(0, 1, 1)
				assert(is_equal(r, 1))
				assert(is_equal(g, 0))
				assert(is_equal(b, 0))
			end)

			it("Should convert green HSB to RGB", function()
				local r, g, b, a = color.hsb2rgb(1/3, 1, 1)
				assert(is_equal(r, 0))
				assert(is_equal(g, 1))
				assert(is_equal(b, 0))
			end)

			it("Should convert blue HSB to RGB", function()
				local r, g, b, a = color.hsb2rgb(2/3, 1, 1)
				assert(is_equal(r, 0))
				assert(is_equal(g, 0))
				assert(is_equal(b, 1))
			end)

			it("Should convert white HSB to RGB", function()
				local r, g, b, a = color.hsb2rgb(0, 0, 1)
				assert(is_equal(r, 1))
				assert(is_equal(g, 1))
				assert(is_equal(b, 1))
			end)

			it("Should convert black HSB to RGB", function()
				local r, g, b, a = color.hsb2rgb(0, 0, 0)
				assert(is_equal(r, 0))
				assert(is_equal(g, 0))
				assert(is_equal(b, 0))
			end)

			it("Should handle custom alpha", function()
				local r, g, b, a = color.hsb2rgb(0, 1, 1, 0.5)
				assert(a == 0.5)
			end)

			it("Should handle nil alpha", function()
				local r, g, b, a = color.hsb2rgb(0, 1, 1, nil)
				assert(a == nil)
			end)
		end)

		describe("rgb2hex", function()
			it("Should convert RGB to hex", function()
				local hex = color.rgb2hex(1, 0, 0)
				assert(hex == "FF0000")
			end)

			it("Should convert RGB to hex with lowercase", function()
				local hex = color.rgb2hex(0, 1, 0)
				assert(hex == "00FF00")
			end)

			it("Should convert RGB to hex with blue", function()
				local hex = color.rgb2hex(0, 0, 1)
				assert(hex == "0000FF")
			end)

			it("Should pad single digit hex values", function()
				local hex = color.rgb2hex(0.1, 0.05, 0.02)
				assert(string.len(hex) == 6)
			end)

			it("Should handle zero values", function()
				local hex = color.rgb2hex(0, 0, 0)
				assert(hex == "000000")
			end)

			it("Should handle maximum values", function()
				local hex = color.rgb2hex(1, 1, 1)
				assert(hex == "FFFFFF")
			end)
		end)

		describe("Round-trip conversions", function()
			it("Should convert RGB to HSB and back", function()
				local r, g, b = 0.5, 0.3, 0.8
				local h, s, v = color.rgb2hsb(r, g, b)
				local r2, g2, b2 = color.hsb2rgb(h, s, v)

				assert(math.abs(r - r2) < 0.01)
				assert(math.abs(g - g2) < 0.01)
				assert(math.abs(b - b2) < 0.01)
			end)

			it("Should convert hex to RGB and back", function()
				local hex = "A3F5C2"
				local r, g, b = color.hex2rgb(hex)
				local hex2 = color.rgb2hex(r, g, b)

				assert(hex:upper() == hex2)
			end)
		end)
	end)
end
