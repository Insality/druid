# druid.hotkey API

> at /druid/extended/hotkey.lua

Druid component to manage hotkeys and trigger callbacks when hotkeys are pressed.

### Setup
Create hotkey component with druid: `hotkey = druid:new_hotkey(keys, callback, callback_argument)`

### Notes
- Hotkey can be triggered by pressing a single key or a combination of keys
- Hotkey supports modificator keys (e.g. Ctrl, Shift, Alt)
- Hotkey can be triggered on key press, release or repeat
- Hotkey can be added or removed at runtime
- Hotkey can be enabled or disabled
- Hotkey can be set to repeat on key hold

## Functions

- [init](#init)
- [add_hotkey](#add_hotkey)
- [is_processing](#is_processing)
- [set_repeat](#set_repeat)
- [bind_node](#bind_node)
## Fields

- [on_hotkey_pressed](#on_hotkey_pressed)
- [on_hotkey_released](#on_hotkey_released)
- [style](#style)
- [druid](#druid)



### init

---
```lua
hotkey:init(keys, callback, [callback_argument])
```

The Hotkey constructor

- **Parameters:**
	- `keys` *(string|string[])*: The keys to be pressed for trigger callback. Should contains one key and any modificator keys
	- `callback` *(function)*: The callback function
	- `[callback_argument]` *(any)*: The argument to pass into the callback function

### add_hotkey

---
```lua
hotkey:add_hotkey(keys, [callback_argument])
```

Add hotkey for component callback

- **Parameters:**
	- `keys` *(string|hash|hash[]|string[])*: that have to be pressed before key pressed to activate
	- `[callback_argument]` *(any)*: The argument to pass into the callback function

- **Returns:**
	- `self` *(druid.hotkey)*: Current instance

### is_processing

---
```lua
hotkey:is_processing()
```

- **Returns:**
	- `` *(boolean)*:

### set_repeat

---
```lua
hotkey:set_repeat(is_enabled_repeated)
```

If true, the callback will be triggered on action.repeated

- **Parameters:**
	- `is_enabled_repeated` *(boolean)*: The flag value

- **Returns:**
	- `self` *(druid.hotkey)*: Current instance

### bind_node

---
```lua
hotkey:bind_node([node])
```

If node is provided, the hotkey can be disabled, if the node is disabled

- **Parameters:**
	- `[node]` *(node|nil)*: The node to bind the hotkey to. Nil to unbind the node

- **Returns:**
	- `self` *(druid.hotkey)*: Current instance


## Fields
<a name="on_hotkey_pressed"></a>
- **on_hotkey_pressed** (_event_): fun(self, context, callback_argument) The event triggered when a hotkey is pressed

<a name="on_hotkey_released"></a>
- **on_hotkey_released** (_event_): fun(self, context, callback_argument) The event triggered when a hotkey is released

<a name="style"></a>
- **style** (_druid.hotkey.style_): The style of the hotkey component

<a name="druid"></a>
- **druid** (_druid.instance_): The Druid Factory used to create components

