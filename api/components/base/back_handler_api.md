# druid.back_handler API

> at /druid/base/back_handler.lua

The component that handles the back handler action, like backspace or android back button


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

- **Parameters:**
	- `[callback]` *(function|nil)*: The callback to call when the back handler is triggered
	- `[params]` *(any)*: Custom args to pass in the callback


## Fields
<a name="on_back"></a>
- **on_back** (_event_): Trigger on back handler action, fun(self, params)

<a name="params"></a>
- **params** (_any_): Custom args to pass in the callback

