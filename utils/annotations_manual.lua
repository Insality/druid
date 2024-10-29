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
---@field len fun(s: string):number
---@field sub fun(s: string, start_index: number, length: number)
---@field reverse fun()
---@field char fun()
---@field unicode fun()
---@field gensub fun()
---@field byte fun()
---@field find fun()
---@field match fun(s: string, m: string)
---@field gmatch fun(s: string, m: string)
---@field gsub fun()
---@field dump fun()
---@field format fun()
---@field lower fun()
---@field upper fun()
---@field rep fun()


---Add generics to some functions.

---Create new component.
---@generic T: druid.base_component
---@param self druid_instance
---@param component T Component module
---@param ... any Other component params to pass it to component:init function
---@return T Component instance
function druid_instance.new(self, component, ...) end

--- Set current component style table.
--- Invoke `on_style_change` on component, if exist. Component should handle  their style changing and store all style params
---@generic T: druid.base_component
---@param self T BaseComponent
---@param druid_style table|nil Druid style module
---@return T BaseComponent
function druid__base_component.set_style(self, druid_style) end

--- Set component template name.
--- Use on all your custom components with GUI layouts used as templates.  It will check parent template name to build full template name in self:get_node()
---@generic T: druid.base_component
---@param self T BaseComponent
---@param template string BaseComponent template name
---@return T BaseComponent
function druid__base_component.set_template(self, template) end

--- Set current component nodes.
--- Use if your component nodes was cloned with `gui.clone_tree` and you got the node tree.
---@generic T: druid.base_component
---@param self T BaseComponent
---@param nodes table BaseComponent nodes table
---@return T BaseComponent
function druid__base_component.set_nodes(self, nodes) end
