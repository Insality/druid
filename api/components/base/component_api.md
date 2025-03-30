# druid.component API

> at /druid/component.lua


## Functions
- [create](#create)
- [create_widget](#create_widget)

- [init](#init)
- [update](#update)
- [on_remove](#on_remove)
- [on_input](#on_input)
- [on_input_interrupt](#on_input_interrupt)
- [on_message](#on_message)
- [on_late_init](#on_late_init)
- [on_focus_lost](#on_focus_lost)
- [on_focus_gained](#on_focus_gained)
- [on_style_change](#on_style_change)
- [on_layout_change](#on_layout_change)
- [on_window_resized](#on_window_resized)
- [on_language_change](#on_language_change)
- [set_style](#set_style)
- [set_template](#set_template)
- [get_template](#get_template)
- [set_nodes](#set_nodes)
- [get_context](#get_context)
- [get_node](#get_node)
- [get_druid](#get_druid)
- [get_name](#get_name)
- [get_parent_name](#get_parent_name)
- [get_input_priority](#get_input_priority)
- [set_input_priority](#set_input_priority)
- [reset_input_priority](#reset_input_priority)
- [get_uid](#get_uid)
- [set_input_enabled](#set_input_enabled)
- [get_input_enabled](#get_input_enabled)
- [get_parent_component](#get_parent_component)
- [get_nodes](#get_nodes)
- [get_childrens](#get_childrens)


## Fields
- [druid](#druid)



### create

---
```lua
component.create([name], [input_priority])
```

Сreate a new component class, which will inherit from the base Druid component.

- **Parameters:**
	- `[name]` *(string|nil)*: The name of the component
	- `[input_priority]` *(number|nil)*: The input priority. The bigger number processed first. Default value: 10

- **Returns:**
	- `` *(druid.component)*:

### create_widget

---
```lua
component.create_widget(self, widget_class, context)
```

Create the Druid component instance

- **Parameters:**
	- `self` *(druid.instance)*: The Druid Factory used to create components
	- `widget_class` *(druid.widget)*:
	- `context` *(table)*:

- **Returns:**
	- `` *(druid.widget)*:

### init

---
```lua
component:init()
```

Called when component is created

### update

---
```lua
component:update()
```

Called every frame

### on_remove

---
```lua
component:on_remove()
```

Called when component is removed

### on_input

---
```lua
component:on_input()
```

Called when input event is triggered

### on_input_interrupt

---
```lua
component:on_input_interrupt()
```

Called when input event is consumed before

### on_message

---
```lua
component:on_message()
```

Called when message is received

### on_late_init

---
```lua
component:on_late_init()
```

Called before update once time after GUI init

### on_focus_lost

---
```lua
component:on_focus_lost()
```

Called when app lost focus

### on_focus_gained

---
```lua
component:on_focus_gained()
```

Called when app gained focus

### on_style_change

---
```lua
component:on_style_change()
```

Called when style is changed

### on_layout_change

---
```lua
component:on_layout_change()
```

Called when GUI layout is changed

### on_window_resized

---
```lua
component:on_window_resized()
```

Called when window is resized

### on_language_change

---
```lua
component:on_language_change()
```

Called when language is changed

### set_style

---
```lua
component:set_style([druid_style])
```

Set component style. Pass nil to clear style

- **Parameters:**
	- `[druid_style]` *(table|nil)*:

- **Returns:**
	- `self` *(<T>)*: The component itself for chaining

### set_template

---
```lua
component:set_template([template])
```

Set component template name. Pass nil to clear template.
This template id used to access nodes inside the template on GUI scene.
Parent template will be added automatically if exist.

- **Parameters:**
	- `[template]` *(string|nil)*:

- **Returns:**
	- `self` *(<T>)*: The component itself for chaining

### get_template

---
```lua
component:get_template()
```

Get full template name.

- **Returns:**
	- `` *(string)*:

### set_nodes

---
```lua
component:set_nodes(nodes)
```

Set current component nodes, returned from `gui.clone_tree` function.

- **Parameters:**
	- `nodes` *(table<hash, node>)*:

- **Returns:**
	- `` *(druid.component)*:

### get_context

---
```lua
component:get_context()
```

Return current component context

- **Returns:**
	- `context` *(any)*: Usually it's self of script but can be any other Druid component

### get_node

---
```lua
component:get_node(node_id)
```

Get component node by node_id. Respect to current template and nodes.

- **Parameters:**
	- `node_id` *(string|node)*:

- **Returns:**
	- `` *(node)*:

### get_druid

---
```lua
component:get_druid([template], [nodes])
```

Get Druid instance for inner component creation.

- **Parameters:**
	- `[template]` *(string|nil)*:
	- `[nodes]` *(table<hash, node>|nil)*:

- **Returns:**
	- `` *(druid.instance)*:

### get_name

---
```lua
component:get_name()
```

Get component name

- **Returns:**
	- `name` *(string)*: The component name + uid

### get_parent_name

---
```lua
component:get_parent_name()
```

Get parent component name

- **Returns:**
	- `parent_name` *(string|nil)*: The parent component name if exist or nil

### get_input_priority

---
```lua
component:get_input_priority()
```

Get component input priority, the bigger number processed first. Default value: 10

- **Returns:**
	- `` *(number)*:

### set_input_priority

---
```lua
component:set_input_priority(value, [is_temporary])
```

Set component input priority, the bigger number processed first. Default value: 10

- **Parameters:**
	- `value` *(number)*:
	- `[is_temporary]` *(boolean|nil)*: If true, the reset input priority will return to previous value

- **Returns:**
	- `self` *(druid.component)*: The component itself for chaining

### reset_input_priority

---
```lua
component:reset_input_priority()
```

Reset component input priority to it's default value, that was set in `create` function or `set_input_priority`

- **Returns:**
	- `self` *(druid.component)*: The component itself for chaining

### get_uid

---
```lua
component:get_uid()
```

Get component UID, unique identifier created in component creation order.

- **Returns:**
	- `uid` *(number)*: The component uid

### set_input_enabled

---
```lua
component:set_input_enabled(state)
```

Set component input state. By default it's enabled.
If input is disabled, the component will not receive input events.
Recursive for all children components.

- **Parameters:**
	- `state` *(boolean)*:

- **Returns:**
	- `self` *(druid.component)*: The component itself for chaining

### get_input_enabled

---
```lua
component:get_input_enabled()
```

Get component input state. By default it's enabled. Can be disabled by `set_input_enabled` function.

- **Returns:**
	- `` *(boolean)*:

### get_parent_component

---
```lua
component:get_parent_component()
```

Get parent component

- **Returns:**
	- `parent_component` *(druid.component|nil)*: The parent component if exist or nil

### get_nodes

---
```lua
component:get_nodes()
```

Get current component nodes

- **Returns:**
	- `` *(table<hash, node>|nil)*:

### get_childrens

---
```lua
component:get_childrens()
```

Return all children components, recursive

- **Returns:**
	- `Array` *(table)*: of childrens if the Druid component instance


## Fields
<a name="druid"></a>
- **druid** (_druid.instance_): Druid instance to create inner components

