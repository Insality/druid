# Optimize Druid Size

From the Druid 1.1 release now all components are included by default. This was done to simplify the usage of Druid and remove the `druid.register` function which raised a lot of questions about using the non-included components.

This also means that the size of the Druid library for the build now is slightly larger than before. While this will be a not issue for most users, for those who want to redure the build size for a kind of ~50kb in case not using a lot of `extended` components, you can strip these components from the build.

## Stripping Components

You need to download and modify the Druid library inside your project. To strip the not used components you need to edit the `druid/system/druid_instance.lua` file.

For example, if you want to strip the `hotkey` component, you need to remove the `new_hotkey` function from the `M` table.

You need to delete these lines:

```lua
local hotkey = require("druid.extended.hotkey")
---Create Hotkey component
---@param keys_array string|string[] Keys for trigger action. Should contains one action key and any amount of modificator keys
---@param callback function|nil The callback function
---@param callback_argument any|nil The argument to pass into the callback function
---@return druid.hotkey component Hotkey component
function M:new_hotkey(keys_array, callback, callback_argument)
	return self:new(hotkey, keys_array, callback, callback_argument)
end
```

Thats all. Now the Druid library will have no any links to the `hotkey` component and the size of the build will be reduced by size of this component.

## Component Sizes

Here is a table with the size of the components in the Druid library at the state of the Druid 1.1 release. Just for information.

| Component       | Size (Desktop) | Size (Mobile) |
|-----------------|----------------|---------------|
| `button`        | 4.36 kb        | 2.42 kb       |
| `text`          | 5.31 kb        | 2.90 kb       |
| `scroll`        | 8.27 kb        | 4.73 kb       |
| `grid`          | 5.97 kb        | 2.87 kb       |
| `blocker`       | 0.66 kb        | 0.45 kb       |
| `back_handler`  | 0.57 kb        | 0.42 kb       |
| `hover`         | 2.31 kb        | 1.34 kb       |
| `drag`          | 3.73 kb        | 2.17 kb       |
| `progress`      | 2.76 kb        | 1.64 kb       |
| `slider`        | 2.67 kb        | 1.66 kb       |
| `swipe`         | 2.02 kb        | 1.23 kb       |
| `input`         | 5.59 kb        | 3.38 kb       |
| `timer`         | 1.47 kb        | 0.94 kb       |
| `layout`        | 4.96 kb        | 2.83 kb       |
| `lang_text`     | 1.10 kb        | 0.63 kb       |
| `hotkey`        | 2.29 kb        | 1.46 kb       |
| `data_list`     | 3.24 kb        | 1.81 kb       |
| `container`     | 6.86 kb        | 3.75 kb       |
| `rich_text`     | 13.24 kb       | 8.27 kb       |
| `rich_input`    | 4.16 kb        | 2.38 kb       |
