# druid.swipe API

> at /druid/extended/swipe.lua


## Functions
- [init](#init)
- [on_late_init](#on_late_init)
- [on_style_change](#on_style_change)
- [on_input](#on_input)
- [on_input_interrupt](#on_input_interrupt)
- [set_click_zone](#set_click_zone)


## Fields
- [node](#node)
- [on_swipe](#on_swipe)
- [style](#style)
- [click_zone](#click_zone)



### init

---
```lua
swipe:init(node_or_node_id, on_swipe_callback)
```

- **Parameters:**
	- `node_or_node_id` *(string|node)*:
	- `on_swipe_callback` *(function)*:

### on_late_init

---
```lua
swipe:on_late_init()
```

### on_style_change

---
```lua
swipe:on_style_change(style)
```

- **Parameters:**
	- `style` *(druid.swipe.style)*:

### on_input

---
```lua
swipe:on_input(action_id, action)
```

- **Parameters:**
	- `action_id` *(hash)*:
	- `action` *(action)*:

- **Returns:**
	- `` *(boolean)*:

### on_input_interrupt

---
```lua
swipe:on_input_interrupt()
```

### set_click_zone

---
```lua
swipe:set_click_zone([zone])
```

Strict swipe click area. Useful for
restrict events outside stencil node

- **Parameters:**
	- `[zone]` *(string|node|nil)*: Gui node


## Fields
<a name="node"></a>
- **node** (_node_)

<a name="on_swipe"></a>
- **on_swipe** (_event_): function(side, dist, dt), side - "left", "right", "up", "down"

<a name="style"></a>
- **style** (_table_)

<a name="click_zone"></a>
- **click_zone** (_node_)

