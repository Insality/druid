# druid.button API

> at /druid/base/button.lua

Druid component to make clickable node with various interaction callbacks


## Functions
- [init](#init)
- [set_animations_disabled](#set_animations_disabled)
- [set_enabled](#set_enabled)
- [is_enabled](#is_enabled)
- [set_click_zone](#set_click_zone)
- [set_key_trigger](#set_key_trigger)
- [get_key_trigger](#get_key_trigger)
- [set_check_function](#set_check_function)
- [set_web_user_interaction](#set_web_user_interaction)


## Fields
- [on_click](#on_click)
- [on_pressed](#on_pressed)
- [on_repeated_click](#on_repeated_click)
- [on_long_click](#on_long_click)
- [on_double_click](#on_double_click)
- [on_hold_callback](#on_hold_callback)
- [on_click_outside](#on_click_outside)
- [node](#node)
- [node_id](#node_id)
- [anim_node](#anim_node)
- [params](#params)
- [hover](#hover)
- [click_zone](#click_zone)
- [start_scale](#start_scale)
- [start_pos](#start_pos)
- [disabled](#disabled)
- [key_trigger](#key_trigger)
- [style](#style)
- [druid](#druid)
- [is_repeated_started](#is_repeated_started)
- [last_pressed_time](#last_pressed_time)
- [last_released_time](#last_released_time)
- [click_in_row](#click_in_row)
- [can_action](#can_action)



### init

---
```lua
button:init(node_or_node_id, [callback], [custom_args], [anim_node])
```

The constructor for the button component

- **Parameters:**
	- `node_or_node_id` *(string|node)*: Node name or GUI Node itself
	- `[callback]` *(fun()|nil)*: Callback on button click
	- `[custom_args]` *(any)*: Custom args for any Button event
	- `[anim_node]` *(string|node|nil)*: Node to animate instead of trigger node

### set_animations_disabled

---
```lua
button:set_animations_disabled()
```

Remove default button style animations

- **Returns:**
	- `self` *(druid.button)*: The current button instance

### set_enabled

---
```lua
button:set_enabled([state])
```

Set button enabled state.
The style.on_set_enabled will be triggered.
Disabled button is not clickable.

- **Parameters:**
	- `[state]` *(boolean|nil)*: Enabled state

- **Returns:**
	- `self` *(druid.button)*: The current button instance

### is_enabled

---
```lua
button:is_enabled()
```

Get button enabled state.
By default all Buttons is enabled on creating.

- **Returns:**
	- `is_enabled` *(boolean)*: True, if button is enabled now, False overwise

### set_click_zone

---
```lua
button:set_click_zone([zone])
```

Set additional button click area.
Useful to restrict click outside out stencil node or scrollable content.
If button node placed inside stencil node, it will be automatically set to this stencil node.

- **Parameters:**
	- `[zone]` *(string|node|nil)*: Gui node

- **Returns:**
	- `self` *(druid.button)*: The current button instance

### set_key_trigger

---
```lua
button:set_key_trigger(key)
```

Set key name to trigger this button by keyboard.

- **Parameters:**
	- `key` *(string|hash)*: The action_id of the input key. Example: "key_space"

- **Returns:**
	- `self` *(druid.button)*: The current button instance

### get_key_trigger

---
```lua
button:get_key_trigger()
```

Get current key name to trigger this button.

- **Returns:**
	- `key_trigger` *(hash)*: The action_id of the input key

### set_check_function

---
```lua
button:set_check_function([check_function], [failure_callback])
```

Set function for additional check for button click availability

- **Parameters:**
	- `[check_function]` *(function|nil)*: Should return true or false. If true - button can be pressed.
	- `[failure_callback]` *(function|nil)*: Function will be called on button click, if check function return false

- **Returns:**
	- `self` *(druid.button)*: The current button instance

### set_web_user_interaction

---
```lua
button:set_web_user_interaction([is_web_mode])
```

Set Button mode to work inside user HTML5 interaction event.
It's required to make protected things like copy & paste text, show mobile keyboard, etc
The HTML5 button's doesn't call any events except on_click event.
If the game is not HTML, html mode will be not enabled

- **Parameters:**
	- `[is_web_mode]` *(boolean|nil)*: If true - button will be called inside html5 callback

- **Returns:**
	- `self` *(druid.button)*: The current button instance


## Fields
<a name="on_click"></a>
- **on_click** (_event_): function(self, custom_args, button_instance)

<a name="on_pressed"></a>
- **on_pressed** (_event_): function(self, custom_args, button_instance)

<a name="on_repeated_click"></a>
- **on_repeated_click** (_event_): function(self, custom_args, button_instance, click_count)

<a name="on_long_click"></a>
- **on_long_click** (_event_): function(self, custom_args, button_instance, hold_time)

<a name="on_double_click"></a>
- **on_double_click** (_event_): function(self, custom_args, button_instance, click_amount)

<a name="on_hold_callback"></a>
- **on_hold_callback** (_event_): function(self, custom_args, button_instance, press_time)

<a name="on_click_outside"></a>
- **on_click_outside** (_event_): function(self, custom_args, button_instance)

<a name="node"></a>
- **node** (_node_): Clickable node

<a name="node_id"></a>
- **node_id** (_hash_): Node id

<a name="anim_node"></a>
- **anim_node** (_node_): Animation node. In default case equals to clickable node

<a name="params"></a>
- **params** (_any_): Custom arguments for any Button event

<a name="hover"></a>
- **hover** (_druid.hover_): Hover component for this button

<a name="click_zone"></a>
- **click_zone** (_node_): Click zone node to restrict click area

<a name="start_scale"></a>
- **start_scale** (_vector3_): Start scale of the button

<a name="start_pos"></a>
- **start_pos** (_vector3_): Start position of the button

<a name="disabled"></a>
- **disabled** (_boolean_): Is button disabled

<a name="key_trigger"></a>
- **key_trigger** (_hash_): Key trigger for this button

<a name="style"></a>
- **style** (_table_): Style for this button

<a name="druid"></a>
- **druid** (_druid.instance_): The Druid Factory used to create components

<a name="is_repeated_started"></a>
- **is_repeated_started** (_boolean_)

<a name="last_pressed_time"></a>
- **last_pressed_time** (_integer_)

<a name="last_released_time"></a>
- **last_released_time** (_integer_)

<a name="click_in_row"></a>
- **click_in_row** (_integer_)

<a name="can_action"></a>
- **can_action** (_boolean_):  Can't interact, if touch outside of button

