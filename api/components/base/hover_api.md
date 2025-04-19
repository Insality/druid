# druid.hover API

> at /druid/base/hover.lua

The component for handling hover events on a node

## Functions

- [init](#init)
- [set_hover](#set_hover)
- [is_hovered](#is_hovered)
- [set_mouse_hover](#set_mouse_hover)
- [is_mouse_hovered](#is_mouse_hovered)
- [set_click_zone](#set_click_zone)
- [set_enabled](#set_enabled)
- [is_enabled](#is_enabled)

## Fields

- [node](#node)
- [on_hover](#on_hover)
- [on_mouse_hover](#on_mouse_hover)
- [style](#style)
- [click_zone](#click_zone)



### init

---
```lua
hover:init(node, on_hover_callback, on_mouse_hover)
```

The constructor for the hover component

- **Parameters:**
	- `node` *(node)*: Gui node
	- `on_hover_callback` *(function)*: Hover callback
	- `on_mouse_hover` *(function)*: On mouse hover callback

### set_hover

---
```lua
hover:set_hover([state])
```

Set hover state

- **Parameters:**
	- `[state]` *(boolean|nil)*: The hover state

### is_hovered

---
```lua
hover:is_hovered()
```

Return current hover state. True if touch action was on the node at current time

- **Returns:**
	- `is_hovered` *(boolean)*: The current hovered state

### set_mouse_hover

---
```lua
hover:set_mouse_hover([state])
```

Set mouse hover state

- **Parameters:**
	- `[state]` *(boolean|nil)*: The mouse hover state

### is_mouse_hovered

---
```lua
hover:is_mouse_hovered()
```

Return current hover state. True if nil action_id (usually desktop mouse) was on the node at current time

- **Returns:**
	- `The` *(boolean)*: current hovered state

### set_click_zone

---
```lua
hover:set_click_zone([zone])
```

Strict hover click area. Useful for no click events outside stencil node

- **Parameters:**
	- `[zone]` *(string|node|nil)*: Gui node

### set_enabled

---
```lua
hover:set_enabled([state])
```

Set enable state of hover component.
If hover is not enabled, it will not generate
any hover events

- **Parameters:**
	- `[state]` *(boolean|nil)*: The hover enabled state

### is_enabled

---
```lua
hover:is_enabled()
```

Return current hover enabled state

- **Returns:**
	- `The` *(boolean)*: hover enabled state


## Fields
<a name="node"></a>
- **node** (_node_): Gui node

<a name="on_hover"></a>
- **on_hover** (_event_): fun(self: druid.hover, is_hover: boolean) Hover event

<a name="on_mouse_hover"></a>
- **on_mouse_hover** (_event_): fun(self: druid.hover, is_hover: boolean) Mouse hover event

<a name="style"></a>
- **style** (_druid.hover.style_): Style of the hover component

<a name="click_zone"></a>
- **click_zone** (_node_): Click zone of the hover component

