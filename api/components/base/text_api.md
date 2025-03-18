# druid.text API

> at /druid/base/text.lua

The component to handle text behaviour over a GUI Text node, mainly used to automatically adjust text size to fit the text area


## Functions
- [init](#init)
- [get_text_size](#get_text_size)
- [get_text_index_by_width](#get_text_index_by_width)
- [set_to](#set_to)
- [set_text](#set_text)
- [get_text](#get_text)
- [set_size](#set_size)
- [set_color](#set_color)
- [set_alpha](#set_alpha)
- [set_scale](#set_scale)
- [set_pivot](#set_pivot)
- [is_multiline](#is_multiline)
- [set_text_adjust](#set_text_adjust)
- [set_minimal_scale](#set_minimal_scale)
- [get_text_adjust](#get_text_adjust)


## Fields
- [node](#node)
- [on_set_text](#on_set_text)
- [on_update_text_scale](#on_update_text_scale)
- [on_set_pivot](#on_set_pivot)
- [style](#style)
- [pos](#pos)
- [node_id](#node_id)
- [start_size](#start_size)
- [text_area](#text_area)
- [adjust_type](#adjust_type)
- [color](#color)
- [last_value](#last_value)
- [last_scale](#last_scale)



### init

---
```lua
text:init(node, [value], [adjust_type])
```

The Text constructor

- **Parameters:**
	- `node` *(string|node)*: Node name or GUI Text Node itself
	- `[value]` *(string|nil)*: Initial text. Default value is node text from GUI scene. Default: nil
	- `[adjust_type]` *(string|nil)*: Adjust type for text. By default is DOWNSCALE. Look const.TEXT_ADJUST for reference. Default: DOWNSCALE

### get_text_size

---
```lua
text:get_text_size([text])
```

Calculate text width with font with respect to trailing space

- **Parameters:**
	- `[text]` *(string|nil)*: The text to calculate the size of, if nil - use current text

- **Returns:**
	- `width` *(number)*: The text width
	- `height` *(number)*: The text height

### get_text_index_by_width

---
```lua
text:get_text_index_by_width(width)
```

Get chars count by width

- **Parameters:**
	- `width` *(number)*: The width to get the chars count of

- **Returns:**
	- `index` *(number)*: The chars count

### set_to

---
```lua
text:set_to(set_to)
```

Set text to text field

- **Parameters:**
	- `set_to` *(string)*: Text for node

- **Returns:**
	- `self` *(druid.text)*: Current text instance

### set_text

---
```lua
text:set_text([new_text])
```

- **Parameters:**
	- `[new_text]` *(any)*:

- **Returns:**
	- `` *(druid.text)*:

### get_text

---
```lua
text:get_text()
```

- **Returns:**
	- `` *(unknown)*:

### set_size

---
```lua
text:set_size(size)
```

Set text area size

- **Parameters:**
	- `size` *(vector3)*: The new text area size

- **Returns:**
	- `self` *(druid.text)*: Current text instance

### set_color

---
```lua
text:set_color(color)
```

Set color

- **Parameters:**
	- `color` *(vector4)*: Color for node

- **Returns:**
	- `self` *(druid.text)*: Current text instance

### set_alpha

---
```lua
text:set_alpha(alpha)
```

Set alpha

- **Parameters:**
	- `alpha` *(number)*: Alpha for node

- **Returns:**
	- `self` *(druid.text)*: Current text instance

### set_scale

---
```lua
text:set_scale(scale)
```

Set scale

- **Parameters:**
	- `scale` *(vector3)*: Scale for node

- **Returns:**
	- `self` *(druid.text)*: Current text instance

### set_pivot

---
```lua
text:set_pivot(pivot)
```

Set text pivot. Text will re-anchor inside text area

- **Parameters:**
	- `pivot` *(userdata)*: The gui.PIVOT_* constant

- **Returns:**
	- `self` *(druid.text)*: Current text instance

### is_multiline

---
```lua
text:is_multiline()
```

Return true, if text with line break

- **Returns:**
	- `Is` *(boolean)*: text node with line break

### set_text_adjust

---
```lua
text:set_text_adjust([adjust_type], [minimal_scale])
```

Set text adjust, refresh the current text visuals, if needed
Values are: "downscale", "trim", "no_adjust", "downscale_limited",
"scroll", "scale_then_scroll", "trim_left", "scale_then_trim", "scale_then_trim_left"

- **Parameters:**
	- `[adjust_type]` *(string|nil)*: See const.TEXT_ADJUST. If pass nil - use current adjust type
	- `[minimal_scale]` *(number|nil)*: To remove minimal scale, use `text:set_minimal_scale(nil)`, if pass nil - not change minimal scale

- **Returns:**
	- `self` *(druid.text)*: Current text instance

### set_minimal_scale

---
```lua
text:set_minimal_scale(minimal_scale)
```

Set minimal scale for DOWNSCALE_LIMITED or SCALE_THEN_SCROLL adjust types

- **Parameters:**
	- `minimal_scale` *(number)*: If pass nil - not use minimal scale

- **Returns:**
	- `self` *(druid.text)*: Current text instance

### get_text_adjust

---
```lua
text:get_text_adjust()
```

Return current text adjust type

- **Returns:**
	- `adjust_type` *(string)*: The current text adjust type


## Fields
<a name="node"></a>
- **node** (_node_): The text node

<a name="on_set_text"></a>
- **on_set_text** (_event_): The event triggered when the text is set, fun(self, text)

<a name="on_update_text_scale"></a>
- **on_update_text_scale** (_event_): The event triggered when the text scale is updated, fun(self, scale, metrics)

<a name="on_set_pivot"></a>
- **on_set_pivot** (_event_): The event triggered when the text pivot is set, fun(self, pivot)

<a name="style"></a>
- **style** (_druid.text.style_): The style of the text

<a name="pos"></a>
- **pos** (_unknown_)

<a name="node_id"></a>
- **node_id** (_unknown_)

<a name="start_size"></a>
- **start_size** (_unknown_)

<a name="text_area"></a>
- **text_area** (_unknown_)

<a name="adjust_type"></a>
- **adjust_type** (_string|nil_)

<a name="color"></a>
- **color** (_unknown_)

<a name="last_value"></a>
- **last_value** (_unknown_)

<a name="last_scale"></a>
- **last_scale** (_vector3_)

