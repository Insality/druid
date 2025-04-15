# druid.widget.properties_panel API

> at /druid/widget/properties_panel/properties_panel.lua

## Functions

- [properties_constructors](#properties_constructors)
- [init](#init)
- [on_remove](#on_remove)
- [on_drag_widget](#on_drag_widget)
- [clear_created_properties](#clear_created_properties)
- [clear](#clear)
- [on_size_changed](#on_size_changed)
- [update](#update)
- [add_checkbox](#add_checkbox)
- [add_slider](#add_slider)
- [add_button](#add_button)
- [add_input](#add_input)
- [add_text](#add_text)
- [add_left_right_selector](#add_left_right_selector)
- [add_vector3](#add_vector3)
- [add_inner_widget](#add_inner_widget)
- [add_widget](#add_widget)
- [remove](#remove)
- [set_hidden](#set_hidden)
- [is_hidden](#is_hidden)
- [set_properties_per_page](#set_properties_per_page)
- [set_page](#set_page)

## Fields

- [root](#root)
- [scroll](#scroll)
- [layout](#layout)
- [container](#container)
- [container_content](#container_content)
- [container_scroll_view](#container_scroll_view)
- [contaienr_scroll_content](#contaienr_scroll_content)
- [button_hidden](#button_hidden)
- [text_header](#text_header)
- [paginator](#paginator)
- [properties](#properties)
- [content](#content)
- [default_size](#default_size)
- [current_page](#current_page)
- [properties_per_page](#properties_per_page)
- [property_checkbox_prefab](#property_checkbox_prefab)
- [property_slider_prefab](#property_slider_prefab)
- [property_button_prefab](#property_button_prefab)
- [property_input_prefab](#property_input_prefab)
- [property_text_prefab](#property_text_prefab)
- [property_left_right_selector_prefab](#property_left_right_selector_prefab)
- [property_vector3_prefab](#property_vector3_prefab)
- [is_dirty](#is_dirty)



### properties_constructors

---
```lua
properties_panel:properties_constructors()
```

List of properties functions to create a new widget. Used to not spawn non-visible widgets but keep the reference

### init

---
```lua
properties_panel:init()
```

### on_remove

---
```lua
properties_panel:on_remove()
```

### on_drag_widget

---
```lua
properties_panel:on_drag_widget([dx], [dy])
```

- **Parameters:**
	- `[dx]` *(any)*:
	- `[dy]` *(any)*:

### clear_created_properties

---
```lua
properties_panel:clear_created_properties()
```

### clear

---
```lua
properties_panel:clear()
```

### on_size_changed

---
```lua
properties_panel:on_size_changed([new_size])
```

- **Parameters:**
	- `[new_size]` *(any)*:

### update

---
```lua
properties_panel:update([dt])
```

- **Parameters:**
	- `[dt]` *(any)*:

### add_checkbox

---
```lua
properties_panel:add_checkbox([on_create])
```

- **Parameters:**
	- `[on_create]` *(fun(checkbox: druid.widget.property_checkbox)|nil)*:

- **Returns:**
	- `` *(druid.widget.properties_panel)*:

### add_slider

---
```lua
properties_panel:add_slider([on_create])
```

- **Parameters:**
	- `[on_create]` *(fun(slider: druid.widget.property_slider)|nil)*:

- **Returns:**
	- `` *(druid.widget.properties_panel)*:

### add_button

---
```lua
properties_panel:add_button([on_create])
```

- **Parameters:**
	- `[on_create]` *(fun(button: druid.widget.property_button)|nil)*:

- **Returns:**
	- `` *(druid.widget.properties_panel)*:

### add_input

---
```lua
properties_panel:add_input([on_create])
```

- **Parameters:**
	- `[on_create]` *(fun(input: druid.widget.property_input)|nil)*:

- **Returns:**
	- `` *(druid.widget.properties_panel)*:

### add_text

---
```lua
properties_panel:add_text([on_create])
```

- **Parameters:**
	- `[on_create]` *(fun(text: druid.widget.property_text)|nil)*:

- **Returns:**
	- `` *(druid.widget.properties_panel)*:

### add_left_right_selector

---
```lua
properties_panel:add_left_right_selector([on_create])
```

- **Parameters:**
	- `[on_create]` *(fun(selector: druid.widget.property_left_right_selector)|nil)*:

- **Returns:**
	- `` *(druid.widget.properties_panel)*:

### add_vector3

---
```lua
properties_panel:add_vector3([on_create])
```

- **Parameters:**
	- `[on_create]` *(fun(vector3: druid.widget.property_vector3)|nil)*:

- **Returns:**
	- `` *(druid.widget.properties_panel)*:

### add_inner_widget

---
```lua
properties_panel:add_inner_widget(widget_class, [template], [nodes], [on_create])
```

- **Parameters:**
	- `widget_class` *(<T:druid.widget>)*:
	- `[template]` *(string|nil)*:
	- `[nodes]` *(node|table<hash, node>|nil)*:
	- `[on_create]` *(fun(widget: <T:druid.widget>)|nil)*:

- **Returns:**
	- `` *(druid.widget.properties_panel)*:

### add_widget

---
```lua
properties_panel:add_widget(create_widget_callback)
```

- **Parameters:**
	- `create_widget_callback` *(fun():druid.widget)*:

- **Returns:**
	- `` *(druid.widget.properties_panel)*:

### remove

---
```lua
properties_panel:remove([widget])
```

- **Parameters:**
	- `[widget]` *(any)*:

### set_hidden

---
```lua
properties_panel:set_hidden([is_hidden])
```

- **Parameters:**
	- `[is_hidden]` *(any)*:

### is_hidden

---
```lua
properties_panel:is_hidden()
```

- **Returns:**
	- `` *(unknown)*:

### set_properties_per_page

---
```lua
properties_panel:set_properties_per_page(properties_per_page)
```

- **Parameters:**
	- `properties_per_page` *(number)*:

### set_page

---
```lua
properties_panel:set_page([page])
```

- **Parameters:**
	- `[page]` *(any)*:


## Fields
<a name="root"></a>
- **root** (_node_)

<a name="scroll"></a>
- **scroll** (_druid.scroll_): Basic Druid scroll component. Handles all scrolling behavior in Druid GUI.

<a name="layout"></a>
- **layout** (_druid.layout_): Druid component to manage the layout of nodes, placing them inside the node size with respect to the size and pivot of each node.

<a name="container"></a>
- **container** (_druid.container_): Druid component to manage the size and positions with other containers relations to create a adaptable layouts.

<a name="container_content"></a>
- **container_content** (_druid.container_): Druid component to manage the size and positions with other containers relations to create a adaptable layouts.

<a name="container_scroll_view"></a>
- **container_scroll_view** (_druid.container_): Druid component to manage the size and positions with other containers relations to create a adaptable layouts.

<a name="contaienr_scroll_content"></a>
- **contaienr_scroll_content** (_druid.container_): Druid component to manage the size and positions with other containers relations to create a adaptable layouts.

<a name="button_hidden"></a>
- **button_hidden** (_druid.button_): Basic Druid input component. Handle input on node and provide different callbacks on touch events.

<a name="text_header"></a>
- **text_header** (_druid.text_): Basic Druid text component. Text components by default have the text size adjusting.

<a name="paginator"></a>
- **paginator** (_druid.widget.property_left_right_selector_)

<a name="properties"></a>
- **properties** (_druid.widget[]_): List of created properties

<a name="content"></a>
- **content** (_node_)

<a name="default_size"></a>
- **default_size** (_vector3_)

<a name="current_page"></a>
- **current_page** (_integer_)

<a name="properties_per_page"></a>
- **properties_per_page** (_integer_)

<a name="property_checkbox_prefab"></a>
- **property_checkbox_prefab** (_node_)

<a name="property_slider_prefab"></a>
- **property_slider_prefab** (_node_)

<a name="property_button_prefab"></a>
- **property_button_prefab** (_node_)

<a name="property_input_prefab"></a>
- **property_input_prefab** (_node_)

<a name="property_text_prefab"></a>
- **property_text_prefab** (_node_)

<a name="property_left_right_selector_prefab"></a>
- **property_left_right_selector_prefab** (_node_)

<a name="property_vector3_prefab"></a>
- **property_vector3_prefab** (_node_)

<a name="is_dirty"></a>
- **is_dirty** (_boolean_)

