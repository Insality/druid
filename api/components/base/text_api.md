# druid.text API

> at /druid/base/text.lua

Basic Druid text component. Text components by default have the text size adjusting.

### Setup
Create text node with druid: `text = druid:new_text(node_name, [initial_value], [text_adjust_type])`

### Notes
- Text component by default have auto adjust text sizing. Text never will be bigger, than text node size, which you can setup in GUI scene.
- Text pivot can be changed with `text:set_pivot`, and text will save their position inside their text size box
- There are several text adjust types:
-   - **"downscale"** - Change text's scale to fit in the text node size (default)
-   - **"trim"** - Trim the text with postfix (default - "...") to fit in the text node size
-   - **"no_adjust"** - No any adjust, like default Defold text node
-   - **"downscale_limited"** - Change text's scale like downscale, but there is limit for text's scale
-   - **"scroll"** - Change text's pivot to imitate scrolling in the text box. Use with stencil node for better effect.
-   - **"scale_then_scroll"** - Combine two modes: first limited downscale, then scroll
-   - **"trim_left"** - Trim the text with postfix (default - "...") to fit in the text node size
-   - **"scale_then_trim"** - Combine two modes: first limited downscale, then trim
-   - **"scale_then_trim_left"** - Combine two modes: first limited downscale, then trim left

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
- [start_pivot](#start_pivot)
- [start_scale](#start_scale)
- [scale](#scale)
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
text:init(node, [value], adjust_type)
```

The Text constructor
```lua
adjust_type:
    | "downscale"
    | "trim"
    | "no_adjust"
    | "downscale_limited"
    | "scroll"
    | "scale_then_scroll"
    | "trim_left"
    | "scale_then_trim"
    | "scale_then_trim_left"
```

- **Parameters:**
	- `node` *(string|node)*: Node name or GUI Text Node itself
	- `[value]` *(string|nil)*: Initial text. Default value is node text from GUI scene. Default: nil
	- `adjust_type` *("downscale"|"downscale_limited"|"no_adjust"|"scale_then_scroll"|"scale_then_trim"...(+5))*: Adjust type for text. By default is "downscale". Options: "downscale", "trim", "no_adjust", "downscale_limited", "scroll", "scale_then_scroll", "trim_left", "scale_then_trim", "scale_then_trim_left"

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
	- `pivot` *(number)*: The gui.PIVOT_* constant

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
text:set_text_adjust(adjust_type, [minimal_scale])
```

Set text adjust, refresh the current text visuals, if needed
```lua
adjust_type:
    | "downscale"
    | "trim"
    | "no_adjust"
    | "downscale_limited"
    | "scroll"
    | "scale_then_scroll"
    | "trim_left"
    | "scale_then_trim"
    | "scale_then_trim_left"
```

- **Parameters:**
	- `adjust_type` *("downscale"|"downscale_limited"|"no_adjust"|"scale_then_scroll"|"scale_then_trim"...(+5))*: The adjust type to set, values: "downscale", "trim", "no_adjust", "downscale_limited", "scroll", "scale_then_scroll", "trim_left", "scale_then_trim", "scale_then_trim_left"
	- `[minimal_scale]` *(number|nil)*: To remove minimal scale, use `text:set_minimal_scale(nil)`, if pass nil - not change minimal scale

- **Returns:**
	- `self` *(druid.text)*: Current text instance

### set_minimal_scale

---
```lua
text:set_minimal_scale(minimal_scale)
```

Set minimal scale for "downscale_limited" or "scale_then_scroll" adjust types

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
- **on_set_text** (_event_): fun(self: druid.text, text: string) The event triggered when the text is set

<a name="on_update_text_scale"></a>
- **on_update_text_scale** (_event_): fun(self: druid.text, scale: vector3, metrics: table) The event triggered when the text scale is updated

<a name="on_set_pivot"></a>
- **on_set_pivot** (_event_): fun(self: druid.text, pivot: userdata) The event triggered when the text pivot is set

<a name="style"></a>
- **style** (_druid.text.style_): The style of the text

<a name="start_pivot"></a>
- **start_pivot** (_number_): The start pivot of the text

<a name="start_scale"></a>
- **start_scale** (_vector3_): The start scale of the text

<a name="scale"></a>
- **scale** (_vector3_): The current scale of the text

<a name="pos"></a>
- **pos** (_unknown_)

<a name="node_id"></a>
- **node_id** (_unknown_)

<a name="start_size"></a>
- **start_size** (_unknown_)

<a name="text_area"></a>
- **text_area** (_unknown_)

<a name="adjust_type"></a>
- **adjust_type** (_string|"downscale"|"downscale_limited"|"no_adjust"|"scale_then_scroll"...(+6)_)

<a name="color"></a>
- **color** (_unknown_)

<a name="last_value"></a>
- **last_value** (_unknown_)

<a name="last_scale"></a>
- **last_scale** (_vector3_)

