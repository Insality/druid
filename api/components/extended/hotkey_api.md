# druid.hotkey API

> at /druid/extended/hotkey.lua


## Functions
- [init](#init)
- [on_style_change](#on_style_change)
- [add_hotkey](#add_hotkey)
- [is_processing](#is_processing)
- [on_focus_gained](#on_focus_gained)
- [on_input](#on_input)
- [set_repeat](#set_repeat)


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

### on_style_change

---
```lua
hotkey:on_style_change(style)
```

- **Parameters:**
	- `style` *(druid.hotkey.style)*:

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
	- `Current` *(druid.hotkey)*: instance

### is_processing

---
```lua
hotkey:is_processing()
```

- **Returns:**
	- `` *(boolean)*:

### on_focus_gained

---
```lua
hotkey:on_focus_gained()
```

### on_input

---
```lua
hotkey:on_input([action_id], action)
```

- **Parameters:**
	- `[action_id]` *(hash|nil)*:
	- `action` *(action)*:

- **Returns:**
	- `` *(boolean)*:

### set_repeat

---
```lua
hotkey:set_repeat(is_enabled_repeated)
```

If true, the callback will be triggered on action.repeated

- **Parameters:**
	- `is_enabled_repeated` *(bool)*: The flag value

- **Returns:**
	- `` *(druid.hotkey)*:


## Fields
<a name="on_hotkey_pressed"></a>
- **on_hotkey_pressed** (_event_)

<a name="on_hotkey_released"></a>
- **on_hotkey_released** (_event_)

<a name="style"></a>
- **style** (_druid.hotkey.style_)

<a name="druid"></a>
- **druid** (_druid.instance_)

