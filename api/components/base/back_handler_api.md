# druid.back_handler API

> at /druid/base/back_handler.lua

Component to handle back button. It handles Android back button and Backspace key.

### Setup
Create back handler component with druid: `druid:new_back_handler(callback)`

### Notes
- Key triggers in `input.binding` should be setup for correct working
- It uses a key_back and key_backspace action ids

## Functions

- [init](#init)

## Fields

- [on_back](#on_back)
- [params](#params)



### init

---
```lua
back_handler:init([callback], [params])
```

The Back Handler constructor

- **Parameters:**
	- `[callback]` *(function|nil)*: The callback to call when the back handler is triggered
	- `[params]` *(any)*: Custom args to pass in the callback


## Fields
<a name="on_back"></a>
- **on_back** (_event_): fun(self: druid.back_handler, params: any?) Trigger on back handler action

<a name="params"></a>
- **params** (_any_): Custom args to pass in the callback

