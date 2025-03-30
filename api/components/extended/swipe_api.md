# druid.swipe API

> at /druid/extended/swipe.lua

The component to manage swipe events over a node


## Functions
- [init](#init)
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

### set_click_zone

---
```lua
swipe:set_click_zone([zone])
```

Set the click zone for the swipe, useful for restricting events outside stencil node

- **Parameters:**
	- `[zone]` *(string|node|nil)*: Gui node


## Fields
<a name="node"></a>
- **node** (_node_): The node to manage the swipe

<a name="on_swipe"></a>
- **on_swipe** (_event_): fun(context, side, dist, dt) The event triggered when a swipe is detected

<a name="style"></a>
- **style** (_druid.swipe.style_): The style of the swipe

<a name="click_zone"></a>
- **click_zone** (_node_): The click zone of the swipe

