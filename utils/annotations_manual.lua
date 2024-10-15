-- Manual Annotations --

---@class druid.component: druid.base_component

---@class druid.rich_text.metrics
---@field width number
---@field height number
---@field offset_x number|nil
---@field offset_y number|nil
---@field max_ascent number
---@field max_descent number
---@field node_size vector3|nil @For images only

---@class druid.rich_text.lines_metrics
---@field text_width number
---@field text_height number
---@field lines table<number, druid.rich_text.metrics>

---@class druid.rich_text.word
---@field node node
---@field relative_scale number
---@field color vector4
---@field position vector3
---@field offset vector3
---@field scale vector3
---@field size vector3
---@field metrics druid.rich_text.metrics
---@field pivot userdata @ The gui.PIVOT_* constant
---@field text string
---@field shadow vector4
---@field outline vector4
---@field font string
---@field image druid.rich_text.image
---@field default_animation string
---@field anchor number
---@field br boolean
---@field nobr boolean
---@field source_text string
---@field image_color vector4
---@field text_color vector4

---@class druid.rich_text.image
---@field texture string
---@field anim string
---@field width number
---@field height number

---@class druid.rich_text.settings
---@field parent node
---@field size number
---@field fonts table<string, string>
---@field scale vector3
---@field color vector4
---@field shadow vector4
---@field outline vector4
---@field position vector3
---@field image_pixel_grid_snap boolean
---@field combine_words boolean
---@field default_animation string
---@field text_prefab node
---@field adjust_scale number
---@field default_texture string
---@field is_multiline boolean
---@field text_leading number
---@field font hash
---@field width number
---@field height number

---@class GUITextMetrics
---@field width number
---@field height number
---@field max_ascent number
---@field max_descent number

---@class utf8
---@field len fun(string: string): number
---@field sub fun(string: string, i: number, j: number): string
---@field gmatch fun(string: string, pattern: string): fun(): string
---@field gsub fun(string: string, pattern: string, repl: string, n: number): string
---@field char fun(...: number): string
---@field byte fun(string: string, i: number, j: number): number


---Add generics to some functions.

---Create new component.
---@generic T: druid.base_component
---@param self druid_instance
---@param component T Component module
---@param ... any Other component params to pass it to component:init function
---@return T Component instance
function druid_instance.new(self, component, ...) end