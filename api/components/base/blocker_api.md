# druid.blocker API

> at /druid/base/blocker.lua


## Functions
- [init](#init)
- [on_input](#on_input)
- [set_enabled](#set_enabled)
- [is_enabled](#is_enabled)


## Fields
- [node](#node)



### init

---
```lua
blocker:init(node)
```

- **Parameters:**
	- `node` *(node)*:

### on_input

---
```lua
blocker:on_input(action_id, action)
```

- **Parameters:**
	- `action_id` *(string)*:
	- `action` *(table)*:

- **Returns:**
	- `` *(boolean)*:

### set_enabled

---
```lua
blocker:set_enabled(state)
```

Set blocker enabled state

- **Parameters:**
	- `state` *(boolean)*:

- **Returns:**
	- `self` *(druid.blocker)*:

### is_enabled

---
```lua
blocker:is_enabled()
```

Get blocker enabled state

- **Returns:**
	- `` *(boolean)*:


## Fields
<a name="node"></a>
- **node** (_node_)

