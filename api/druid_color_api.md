# druid.color API

> at /druid/color.lua

Color palette and utility functions for working with colors.
Supports palette management, hex conversion, RGB/HSB conversion, and color interpolation.

## Functions

- [get_color](#get_color)
- [add_palette](#add_palette)
- [get_palette](#get_palette)
- [set_color](#set_color)
- [lerp](#lerp)
- [hex2rgb](#hex2rgb)
- [hex2vector4](#hex2vector4)
- [rgb2hsb](#rgb2hsb)
- [hsb2rgb](#hsb2rgb)
- [rgb2hex](#rgb2hex)


### get_color

---
```lua
color.get_color(color_id)
```

Get color by ID from palette, hex string, or return vector as-is.
If color_id is not found in palette and not a hex string, returns white.

- **Parameters:**
	- `color_id` *(string|vector3|vector4)*: Color id from palette, hex color string, or vector

- **Returns:**
	- `` *(vector4)*:

### add_palette

---
```lua
color.add_palette(palette_data)
```

Add colors to palette. Colors can be hex strings or vector4 values.

- **Parameters:**
	- `palette_data` *(table<string, string|vector4>)*: Table with color IDs as keys

### get_palette

---
```lua
color.get_palette()
```

Get all palette colors.

- **Returns:**
	- `` *(table<string, vector4>)*:

### set_color

---
```lua
color.set_color(gui_node, color)
```

Set GUI node color. Does not change alpha.

- **Parameters:**
	- `gui_node` *(node)*:
	- `color` *(string|vector3|vector4)*:

### lerp

---
```lua
color.lerp(t, color1, color2)
```

Interpolate between two colors using HSB space (better visual results than RGB).

- **Parameters:**
	- `t` *(number)*: Lerp value (0 = color1, 1 = color2)
	- `color1` *(vector4)*:
	- `color2` *(vector4)*:

- **Returns:**
	- `` *(vector4)*:

### hex2rgb

---
```lua
color.hex2rgb(hex)
```

Convert hex string to RGB values (0-1 range). Supports #RGB and #RRGGBB formats.

- **Parameters:**
	- `hex` *(string)*:

- **Returns:**
	- `` *(number)*:
	- `` *(number)*:
	- `` *(number)*:

### hex2vector4

---
```lua
color.hex2vector4(hex, [alpha])
```

Convert hex string to vector4.

- **Parameters:**
	- `hex` *(string)*:
	- `[alpha]` *(number|nil)*: Default is 1

- **Returns:**
	- `` *(vector4)*:

### rgb2hsb

---
```lua
color.rgb2hsb(r, g, b, [alpha])
```

Convert RGB to HSB.

- **Parameters:**
	- `r` *(number)*:
	- `g` *(number)*:
	- `b` *(number)*:
	- `[alpha]` *(number|nil)*:

- **Returns:**
	- `` *(number)*:
	- `` *(number)*:
	- `` *(number)*:
	- `` *(number)*:

### hsb2rgb

---
```lua
color.hsb2rgb(h, s, v, [alpha])
```

Convert HSB to RGB.

- **Parameters:**
	- `h` *(number)*:
	- `s` *(number)*:
	- `v` *(number)*:
	- `[alpha]` *(number|nil)*:

- **Returns:**
	- `` *(number)*:
	- `` *(number)*:
	- `` *(number)*:
	- `` *(number|nil)*:

### rgb2hex

---
```lua
color.rgb2hex(red, green, blue)
```

Convert RGB to hex string (uppercase, without #).

- **Parameters:**
	- `red` *(number)*:
	- `green` *(number)*:
	- `blue` *(number)*:

- **Returns:**
	- `hex_string` *(string)*: Example: "FF0000", without "#" prefix

