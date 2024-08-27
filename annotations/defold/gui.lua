--[[
  Generated with github.com/astrochili/defold-annotations
  Defold 1.8.0

  GUI API documentation
--]]

---@diagnostic disable: lowercase-global
---@diagnostic disable: missing-return
---@diagnostic disable: duplicate-doc-param
---@diagnostic disable: duplicate-set-field

---@class defold_api.gui
gui = {}

---Adjust mode is used when the screen resolution differs from the project settings.
---The fit mode ensures that the entire node is visible in the adjusted gui scene.
gui.ADJUST_FIT = nil

---Adjust mode is used when the screen resolution differs from the project settings.
---The stretch mode ensures that the node is displayed as is in the adjusted gui scene, which might scale it non-uniformally.
gui.ADJUST_STRETCH = nil

---Adjust mode is used when the screen resolution differs from the project settings.
---The zoom mode ensures that the node fills its entire area and might make the node exceed it.
gui.ADJUST_ZOOM = nil

---bottom y-anchor
gui.ANCHOR_BOTTOM = nil

---left x-anchor
gui.ANCHOR_LEFT = nil

---no anchor
gui.ANCHOR_NONE = nil

---right x-anchor
gui.ANCHOR_RIGHT = nil

---top y-anchor
gui.ANCHOR_TOP = nil

---additive blending
gui.BLEND_ADD = nil

---additive alpha blending
gui.BLEND_ADD_ALPHA = nil

---alpha blending
gui.BLEND_ALPHA = nil

---multiply blending
gui.BLEND_MULT = nil

---screen blending
gui.BLEND_SCREEN = nil

---clipping mode none
gui.CLIPPING_MODE_NONE = nil

---clipping mode stencil
gui.CLIPPING_MODE_STENCIL = nil

---in-back
gui.EASING_INBACK = nil

---in-bounce
gui.EASING_INBOUNCE = nil

---in-circlic
gui.EASING_INCIRC = nil

---in-cubic
gui.EASING_INCUBIC = nil

---in-elastic
gui.EASING_INELASTIC = nil

---in-exponential
gui.EASING_INEXPO = nil

---in-out-back
gui.EASING_INOUTBACK = nil

---in-out-bounce
gui.EASING_INOUTBOUNCE = nil

---in-out-circlic
gui.EASING_INOUTCIRC = nil

---in-out-cubic
gui.EASING_INOUTCUBIC = nil

---in-out-elastic
gui.EASING_INOUTELASTIC = nil

---in-out-exponential
gui.EASING_INOUTEXPO = nil

---in-out-quadratic
gui.EASING_INOUTQUAD = nil

---in-out-quartic
gui.EASING_INOUTQUART = nil

---in-out-quintic
gui.EASING_INOUTQUINT = nil

---in-out-sine
gui.EASING_INOUTSINE = nil

---in-quadratic
gui.EASING_INQUAD = nil

---in-quartic
gui.EASING_INQUART = nil

---in-quintic
gui.EASING_INQUINT = nil

---in-sine
gui.EASING_INSINE = nil

---linear interpolation
gui.EASING_LINEAR = nil

---out-back
gui.EASING_OUTBACK = nil

---out-bounce
gui.EASING_OUTBOUNCE = nil

---out-circlic
gui.EASING_OUTCIRC = nil

---out-cubic
gui.EASING_OUTCUBIC = nil

---out-elastic
gui.EASING_OUTELASTIC = nil

---out-exponential
gui.EASING_OUTEXPO = nil

---out-in-back
gui.EASING_OUTINBACK = nil

---out-in-bounce
gui.EASING_OUTINBOUNCE = nil

---out-in-circlic
gui.EASING_OUTINCIRC = nil

---out-in-cubic
gui.EASING_OUTINCUBIC = nil

---out-in-elastic
gui.EASING_OUTINELASTIC = nil

---out-in-exponential
gui.EASING_OUTINEXPO = nil

---out-in-quadratic
gui.EASING_OUTINQUAD = nil

---out-in-quartic
gui.EASING_OUTINQUART = nil

---out-in-quintic
gui.EASING_OUTINQUINT = nil

---out-in-sine
gui.EASING_OUTINSINE = nil

---out-quadratic
gui.EASING_OUTQUAD = nil

---out-quartic
gui.EASING_OUTQUART = nil

---out-quintic
gui.EASING_OUTQUINT = nil

---out-sine
gui.EASING_OUTSINE = nil

---default keyboard
gui.KEYBOARD_TYPE_DEFAULT = nil

---email keyboard
gui.KEYBOARD_TYPE_EMAIL = nil

---number input keyboard
gui.KEYBOARD_TYPE_NUMBER_PAD = nil

---password keyboard
gui.KEYBOARD_TYPE_PASSWORD = nil

---elliptical pie node bounds
gui.PIEBOUNDS_ELLIPSE = nil

---rectangular pie node bounds
gui.PIEBOUNDS_RECTANGLE = nil

---center pivot
gui.PIVOT_CENTER = nil

---east pivot
gui.PIVOT_E = nil

---north pivot
gui.PIVOT_N = nil

---north-east pivot
gui.PIVOT_NE = nil

---north-west pivot
gui.PIVOT_NW = nil

---south pivot
gui.PIVOT_S = nil

---south-east pivot
gui.PIVOT_SE = nil

---south-west pivot
gui.PIVOT_SW = nil

---west pivot
gui.PIVOT_W = nil

---loop backward
gui.PLAYBACK_LOOP_BACKWARD = nil

---loop forward
gui.PLAYBACK_LOOP_FORWARD = nil

---ping pong loop
gui.PLAYBACK_LOOP_PINGPONG = nil

---once backward
gui.PLAYBACK_ONCE_BACKWARD = nil

---once forward
gui.PLAYBACK_ONCE_FORWARD = nil

---once forward and then backward
gui.PLAYBACK_ONCE_PINGPONG = nil

---color property
gui.PROP_COLOR = nil

---euler property
gui.PROP_EULER = nil

---fill_angle property
gui.PROP_FILL_ANGLE = nil

---inner_radius property
gui.PROP_INNER_RADIUS = nil

---outline color property
gui.PROP_OUTLINE = nil

---position property
gui.PROP_POSITION = nil

---rotation property
gui.PROP_ROTATION = nil

---scale property
gui.PROP_SCALE = nil

---shadow color property
gui.PROP_SHADOW = nil

---size property
gui.PROP_SIZE = nil

---slice9 property
gui.PROP_SLICE9 = nil

---The provided data is not in the expected format or is in some other way
---incorrect, for instance the image data provided to gui.new_texture().
gui.RESULT_DATA_ERROR = nil

---The system is out of resources, for instance when trying to create a new
---texture using gui.new_texture().
gui.RESULT_OUT_OF_RESOURCES = nil

---The texture id already exists when trying to use gui.new_texture().
gui.RESULT_TEXTURE_ALREADY_EXISTS = nil

---The size of the node is determined by the currently assigned texture.
gui.SIZE_MODE_AUTO = nil

---The size of the node is determined by the size set in the editor, the constructor or by gui.set_size()
gui.SIZE_MODE_MANUAL = nil

---This starts an animation of a node property according to the specified parameters.
---If the node property is already being animated, that animation will be canceled and
---replaced by the new one. Note however that several different node properties
---can be animated simultaneously. Use gui.cancel_animation to stop the animation
---before it has completed.
---Composite properties of type vector3, vector4 or quaternion
---also expose their sub-components (x, y, z and w).
---You can address the components individually by suffixing the name with a dot '.'
---and the name of the component.
---For instance, "position.x" (the position x coordinate) or "color.w"
---(the color alpha value).
---If a complete_function (Lua function) is specified, that function will be called
---when the animation has completed.
---By starting a new animation in that function, several animations can be sequenced
---together. See the examples below for more information.
---@param node node node to animate
---@param property string|constant property to animate
---
---"position"
---"rotation"
---"euler"
---"scale"
---"color"
---"outline"
---"shadow"
---"size"
---"fill_angle" (pie)
---"inner_radius" (pie)
---"slice9" (slice9)
---
---The following property constants are defined equaling the corresponding property string names.
---
---gui.PROP_POSITION
---gui.PROP_ROTATION
---gui.PROP_EULER
---gui.PROP_SCALE
---gui.PROP_COLOR
---gui.PROP_OUTLINE
---gui.PROP_SHADOW
---gui.PROP_SIZE
---gui.PROP_FILL_ANGLE
---gui.PROP_INNER_RADIUS
---gui.PROP_SLICE9
---
---@param to number|vector3|vector4|quaternion target property value
---@param easing constant|vector4|vector3 easing to use during animation.
---     Either specify one of the gui.EASING_* constants or provide a
---     vector with a custom curve. See the animation guide for more information.
---@param duration number duration of the animation in seconds.
---@param delay number|nil delay before the animation starts in seconds.
---@param complete_function fun(self, node)|nil function to call when the
---     animation has completed
---@param playback constant|nil playback mode
---
---gui.PLAYBACK_ONCE_FORWARD
---gui.PLAYBACK_ONCE_BACKWARD
---gui.PLAYBACK_ONCE_PINGPONG
---gui.PLAYBACK_LOOP_FORWARD
---gui.PLAYBACK_LOOP_BACKWARD
---gui.PLAYBACK_LOOP_PINGPONG
---
function gui.animate(node, property, to, easing, duration, delay, complete_function, playback) end

---If an animation of the specified node is currently running (started by gui.animate), it will immediately be canceled.
---@param node node node that should have its animation canceled
---@param property string|constant property for which the animation should be canceled
---
---"position"
---"rotation"
---"euler"
---"scale"
---"color"
---"outline"
---"shadow"
---"size"
---"fill_angle" (pie)
---"inner_radius" (pie)
---"slice9" (slice9)
---
function gui.cancel_animation(node, property) end

---Cancels any running flipbook animation on the specified node.
---@param node node node cancel flipbook animation for
function gui.cancel_flipbook(node) end

---Make a clone instance of a node. The cloned node will be identical to the
---original node, except the id which is generated as the string "node" plus
---a sequential unsigned integer value.
---This function does not clone the supplied node's children nodes.
---Use gui.clone_tree for that purpose.
---@param node node node to clone
---@return node clone the cloned node
function gui.clone(node) end

---Make a clone instance of a node and all its children.
---Use gui.clone to clone a node excluding its children.
---@param node node root node to clone
---@return table<string|hash, node> clones a table mapping node ids to the corresponding cloned nodes
function gui.clone_tree(node) end

---Deletes the specified node. Any child nodes of the specified node will be
---recursively deleted.
---@param node node node to delete
function gui.delete_node(node) end

---Delete a dynamically created texture.
---@param texture string|hash texture id
function gui.delete_texture(texture) end

---Instead of using specific getters such as gui.get_position or gui.get_scale,
---you can use gui.get instead and supply the property as a string or a hash.
---While this function is similar to go.get, there are a few more restrictions
---when operating in the gui namespace. Most notably, only these propertie identifiers are supported:
---"position"
---"rotation"
---"euler"
---"scale"
---"color"
---"outline"
---"shadow"
---"size"
---"fill_angle" (pie)
---"inner_radius" (pie)
---"slice9" (slice9)
---The value returned will either be a vmath.vector4 or a single number, i.e getting the "position"
---property will return a vec4 while getting the "position.x" property will return a single value.
---@param node node node to get the property for
---@param property string|hash|constant the property to retrieve
function gui.get(node, property) end

---Returns the adjust mode of a node.
---The adjust mode defines how the node will adjust itself to screen
---resolutions that differs from the one in the project settings.
---@param node node node from which to get the adjust mode (node)
---@return constant adjust_mode the current adjust mode
---
---gui.ADJUST_FIT
---gui.ADJUST_ZOOM
---gui.ADJUST_STRETCH
---
function gui.get_adjust_mode(node) end

---gets the node alpha
---@param node node node from which to get alpha
function gui.get_alpha(node) end

---Returns the blend mode of a node.
---Blend mode defines how the node will be blended with the background.
---@param node node node from which to get the blend mode
---@return constant blend_mode blend mode
---
---gui.BLEND_ALPHA
---gui.BLEND_ADD
---gui.BLEND_ADD_ALPHA
---gui.BLEND_MULT
---gui.BLEND_SCREEN
---
function gui.get_blend_mode(node) end

---If node is set as an inverted clipping node, it will clip anything inside as opposed to outside.
---@param node node node from which to get the clipping inverted state
---@return boolean inverted true or false
function gui.get_clipping_inverted(node) end

---Clipping mode defines how the node will clip it's children nodes
---@param node node node from which to get the clipping mode
---@return constant clipping_mode clipping mode
---
---  gui.CLIPPING_MODE_NONE
---  gui.CLIPPING_MODE_STENCIL
---
function gui.get_clipping_mode(node) end

---If node is set as visible clipping node, it will be shown as well as clipping. Otherwise, it will only clip but not show visually.
---@param node node node from which to get the clipping visibility state
---@return boolean visible true or false
function gui.get_clipping_visible(node) end

---Returns the color of the supplied node. The components
---of the returned vector4 contains the color channel values:
---Component
---Color value
---x
---Red value
---y
---Green value
---z
---Blue value
---w
---Alpha value
---@param node node node to get the color from
---@return vector4 color node color
function gui.get_color(node) end

---Returns the rotation of the supplied node.
---The rotation is expressed in degree Euler angles.
---@param node node node to get the rotation from
---@return vector3 rotation node rotation
function gui.get_euler(node) end

---Returns the sector angle of a pie node.
---@param node node node from which to get the fill angle
---@return number angle sector angle
function gui.get_fill_angle(node) end

---Get node flipbook animation.
---@param node node node to get flipbook animation from
---@return hash animation animation id
function gui.get_flipbook(node) end

---This is only useful nodes with flipbook animations. Gets the normalized cursor of the flipbook animation on a node.
---@param node node node to get the cursor for (node)
---@return number cursor cursor value
function gui.get_flipbook_cursor(node) end

---This is only useful nodes with flipbook animations. Gets the playback rate of the flipbook animation on a node.
---@param node node node to set the cursor for
---@return number rate playback rate
function gui.get_flipbook_playback_rate(node) end

---This is only useful for text nodes. The font must be mapped to the gui scene in the gui editor.
---@param node node node from which to get the font
---@return hash font font id
function gui.get_font(node) end

---This is only useful for text nodes. The font must be mapped to the gui scene in the gui editor.
---@param font_name hash|string font of which to get the path hash
---@return hash hash path hash to resource
function gui.get_font_resource(font_name) end

---Returns the scene height.
---@return number height scene height
function gui.get_height() end

---Retrieves the id of the specified node.
---@param node node the node to retrieve the id from
---@return hash id the id of the node
function gui.get_id(node) end

---Retrieve the index of the specified node among its siblings.
---The index defines the order in which a node appear in a GUI scene.
---Higher index means the node is drawn on top of lower indexed nodes.
---@param node node the node to retrieve the id from
---@return number index the index of the node
function gui.get_index(node) end

---gets the node inherit alpha state
---@param node node node from which to get the inherit alpha state
function gui.get_inherit_alpha(node) end

---Returns the inner radius of a pie node.
---The radius is defined along the x-axis.
---@param node node node from where to get the inner radius
---@return number radius inner radius
function gui.get_inner_radius(node) end

---The layer must be mapped to the gui scene in the gui editor.
---@param node node node from which to get the layer
---@return hash layer layer id
function gui.get_layer(node) end

---gets the scene current layout
---@return hash layout layout id
function gui.get_layout() end

---Returns the leading value for a text node.
---@param node node node from where to get the leading
---@return number leading leading scaling value (default=1)
function gui.get_leading(node) end

---Returns whether a text node is in line-break mode or not.
---This is only useful for text nodes.
---@param node node node from which to get the line-break for
---@return boolean line_break true or false
function gui.get_line_break(node) end

---Returns the material of a node.
---The material must be mapped to the gui scene in the gui editor.
---@param node node node to get the material for
function gui.get_material(node) end

---Retrieves the node with the specified id.
---@param id string|hash id of the node to retrieve
---@return node instance a new node instance
function gui.get_node(id) end

---Returns the outer bounds mode for a pie node.
---@param node node node from where to get the outer bounds mode
---@return constant bounds_mode the outer bounds mode of the pie node:
---
---gui.PIEBOUNDS_RECTANGLE
---gui.PIEBOUNDS_ELLIPSE
---
function gui.get_outer_bounds(node) end

---Returns the outline color of the supplied node.
---See gui.get_color for info how vectors encode color values.
---@param node node node to get the outline color from
---@return vector4 color outline color
function gui.get_outline(node) end

---Returns the parent node of the specified node.
---If the supplied node does not have a parent, nil is returned.
---@param node node the node from which to retrieve its parent
---@return node|nil parent parent instance or nil
function gui.get_parent(node) end

---Get the paricle fx for a gui node
---@param node node node to get particle fx for
---@return hash particlefx particle fx id
function gui.get_particlefx(node) end

---Returns the number of generated vertices around the perimeter
---of a pie node.
---@param node node pie node
---@return number vertices vertex count
function gui.get_perimeter_vertices(node) end

---The pivot specifies how the node is drawn and rotated from its position.
---@param node node node to get pivot from
---@return constant pivot pivot constant
---
---  gui.PIVOT_CENTER
---  gui.PIVOT_N
---  gui.PIVOT_NE
---  gui.PIVOT_E
---  gui.PIVOT_SE
---  gui.PIVOT_S
---  gui.PIVOT_SW
---  gui.PIVOT_W
---  gui.PIVOT_NW
---
function gui.get_pivot(node) end

---Returns the position of the supplied node.
---@param node node node to get the position from
---@return vector3 position node position
function gui.get_position(node) end

---Returns the rotation of the supplied node.
---The rotation is expressed as a quaternion
---@param node node node to get the rotation from
---@return quaternion rotation node rotation
function gui.get_rotation(node) end

---Returns the scale of the supplied node.
---@param node node node to get the scale from
---@return vector3 scale node scale
function gui.get_scale(node) end

---Returns the screen position of the supplied node. This function returns the
---calculated transformed position of the node, taking into account any parent node
---transforms.
---@param node node node to get the screen position from
---@return vector3 position node screen position
function gui.get_screen_position(node) end

---Returns the shadow color of the supplied node.
---See gui.get_color for info how vectors encode color values.
---@param node node node to get the shadow color from
---@return vector4 color node shadow color
function gui.get_shadow(node) end

---Returns the size of the supplied node.
---@param node node node to get the size from
---@return vector3 size node size
function gui.get_size(node) end

---Returns the size of a node.
---The size mode defines how the node will adjust itself in size. Automatic
---size mode alters the node size based on the node's content. Automatic size
---mode works for Box nodes and Pie nodes which will both adjust their size
---to match the assigned image. Particle fx and Text nodes will ignore
---any size mode setting.
---@param node node node from which to get the size mode (node)
---@return constant size_mode the current size mode
---
---gui.SIZE_MODE_MANUAL
---gui.SIZE_MODE_AUTO
---
function gui.get_size_mode(node) end

---Returns the slice9 configuration values for the node.
---@param node node node to manipulate
---@return vector4 values configuration values
function gui.get_slice9(node) end

---Returns the text value of a text node. This is only useful for text nodes.
---@param node node node from which to get the text
---@return string text text value
function gui.get_text(node) end

---Returns the texture of a node.
---This is currently only useful for box or pie nodes.
---The texture must be mapped to the gui scene in the gui editor.
---@param node node node to get texture from
---@return hash texture texture id
function gui.get_texture(node) end

---Returns the tracking value of a text node.
---@param node node node from where to get the tracking
---@return number tracking tracking scaling number (default=0)
function gui.get_tracking(node) end

---Get a node and all its children as a Lua table.
---@param node node root node to get node tree from
---@return table<string|hash, node> clones a table mapping node ids to the corresponding nodes
function gui.get_tree(node) end

---Returns true if a node is visible and false if it's not.
---Invisible nodes are not rendered.
---@param node node node to query
---@return boolean visible whether the node is visible or not
function gui.get_visible(node) end

---Returns the scene width.
---@return number width scene width
function gui.get_width() end

---The x-anchor specifies how the node is moved when the game is run in a different resolution.
---@param node node node to get x-anchor from
---@return constant anchor anchor constant
---
---gui.ANCHOR_NONE
---gui.ANCHOR_LEFT
---gui.ANCHOR_RIGHT
---
function gui.get_xanchor(node) end

---The y-anchor specifies how the node is moved when the game is run in a different resolution.
---@param node node node to get y-anchor from
---@return constant anchor anchor constant
---
---gui.ANCHOR_NONE
---gui.ANCHOR_TOP
---gui.ANCHOR_BOTTOM
---
function gui.get_yanchor(node) end

---Hides the on-display touch keyboard on the device.
function gui.hide_keyboard() end

---Returns true if a node is enabled and false if it's not.
---Disabled nodes are not rendered and animations acting on them are not evaluated.
---@param node node node to query
---@param recursive boolean|nil check hierarchy recursively
---@return boolean enabled whether the node is enabled or not
function gui.is_enabled(node, recursive) end

---Alters the ordering of the two supplied nodes by moving the first node
---above the second.
---If the second argument is nil the first node is moved to the top.
---@param node node to move
---@param reference node|nil reference node above which the first node should be moved
function gui.move_above(node, reference) end

---Alters the ordering of the two supplied nodes by moving the first node
---below the second.
---If the second argument is nil the first node is moved to the bottom.
---@param node node to move
---@param reference node|nil reference node below which the first node should be moved
function gui.move_below(node, reference) end

---Dynamically create a new box node.
---@param pos vector3|vector4 node position
---@param size vector3 node size
---@return node node new box node
function gui.new_box_node(pos, size) end

---Dynamically create a particle fx node.
---@param pos vector3|vector4 node position
---@param particlefx hash|string particle fx resource name
---@return node node new particle fx node
function gui.new_particlefx_node(pos, particlefx) end

---Dynamically create a new pie node.
---@param pos vector3|vector4 node position
---@param size vector3 node size
---@return node node new pie node
function gui.new_pie_node(pos, size) end

---Dynamically create a new text node.
---@param pos vector3|vector4 node position
---@param text string node text
---@return node node new text node
function gui.new_text_node(pos, text) end

---Dynamically create a new texture.
---@param texture_id string|hash texture id
---@param width number texture width
---@param height number texture height
---@param type string|constant texture type
---
---"rgb" - RGB
---"rgba" - RGBA
---"l" - LUMINANCE
---
---@param buffer string texture data
---@param flip boolean flip texture vertically
---@return boolean success texture creation was successful
---@return number code one of the gui.RESULT_* codes if unsuccessful
function gui.new_texture(texture_id, width, height, type, buffer, flip) end

---Tests whether a coordinate is within the bounding box of a
---node.
---@param node node node to be tested for picking
---@param x number x-coordinate (see on_input )
---@param y number y-coordinate (see on_input )
---@return boolean pickable pick result
function gui.pick_node(node, x, y) end

---Play flipbook animation on a box or pie node.
---The current node texture must contain the animation.
---Use this function to set one-frame still images on the node.
---@param node node node to set animation for
---@param animation string|hash animation id
---@param complete_function fun(self, node)|nil optional function to call when the animation has completed
---
---self
---
---object The current object.
---
---node
---
---node The node that is animated.
---
---
---@param play_properties { offset:number|nil, playback_rate:number|nil }|nil optional table with properties
---
---offset
---number The normalized initial value of the animation cursor when the animation starts playing
---playback_rate
---number The rate with which the animation will be played. Must be positive
---
function gui.play_flipbook(node, animation, complete_function, play_properties) end

---Plays the paricle fx for a gui node
---@param node node node to play particle fx for
---@param emitter_state_function fun(self, node, emitter, state)|nil optional callback function that will be called when an emitter attached to this particlefx changes state.
---
---self
---object The current object
---node
---hash The particle fx node, or nil if the node was deleted
---emitter
---hash The id of the emitter
---state
---constant the new state of the emitter:
---
---
---particlefx.EMITTER_STATE_SLEEPING
---particlefx.EMITTER_STATE_PRESPAWN
---particlefx.EMITTER_STATE_SPAWNING
---particlefx.EMITTER_STATE_POSTSPAWN
---
function gui.play_particlefx(node, emitter_state_function) end

---Resets the input context of keyboard. This will clear marked text.
function gui.reset_keyboard() end

---Resets the node material to the material assigned in the gui scene.
---@param node node node to reset the material for
function gui.reset_material(node) end

---Resets all nodes in the current GUI scene to their initial state.
---The reset only applies to static node loaded from the scene.
---Nodes that are created dynamically from script are not affected.
function gui.reset_nodes() end

---Convert the screen position to the local position of supplied node
---@param node node node used for getting local transformation matrix
---@param screen_position vector3 screen position
---@return vector3 local_position local position
function gui.screen_to_local(node, screen_position) end

---Instead of using specific setteres such as gui.set_position or gui.set_scale,
---you can use gui.set instead and supply the property as a string or a hash.
---While this function is similar to go.get and go.set, there are a few more restrictions
---when operating in the gui namespace. Most notably, only these propertie identifiers are supported:
---"position"
---"rotation"
---"euler"
---"scale"
---"color"
---"outline"
---"shadow"
---"size"
---"fill_angle" (pie)
---"inner_radius" (pie)
---"slice9" (slice9)
---The value to set must either be a vmath.vector4, vmath.vector3, vmath.quat or a single number and depends on the property name you want to set.
---I.e when setting the "position" property, you need to use a vmath.vector4 and when setting a single component of the property,
---such as "position.x", you need to use a single value.
---Note: When setting the rotation using the "rotation" property, you need to pass in a vmath.quat. This behaviour is different than from the gui.set_rotation function,
---the intention is to move new functionality closer to go namespace so that migrating between gui and go is easier. To set the rotation using degrees instead,
---use the "euler" property instead. The rotation and euler properties are linked, changing one of them will change the backing data of the other.
---@param node node node to set the property for
---@param property string|hash|constant the property to set
---@param value number|vector4|vector3|quaternion the property to set
function gui.set(node, property, value) end

---Sets the adjust mode on a node.
---The adjust mode defines how the node will adjust itself to screen
---resolutions that differs from the one in the project settings.
---@param node node node to set adjust mode for
---@param adjust_mode constant adjust mode to set
---
---gui.ADJUST_FIT
---gui.ADJUST_ZOOM
---gui.ADJUST_STRETCH
---
function gui.set_adjust_mode(node, adjust_mode) end

---sets the node alpha
---@param node node node for which to set alpha
---@param alpha number 0..1 alpha color
function gui.set_alpha(node, alpha) end

---Set the blend mode of a node.
---Blend mode defines how the node will be blended with the background.
---@param node node node to set blend mode for
---@param blend_mode constant blend mode to set
---
---gui.BLEND_ALPHA
---gui.BLEND_ADD
---gui.BLEND_ADD_ALPHA
---gui.BLEND_MULT
---gui.BLEND_SCREEN
---
function gui.set_blend_mode(node, blend_mode) end

---If node is set as an inverted clipping node, it will clip anything inside as opposed to outside.
---@param node node node to set clipping inverted state for
---@param inverted boolean true or false
function gui.set_clipping_inverted(node, inverted) end

---Clipping mode defines how the node will clip it's children nodes
---@param node node node to set clipping mode for
---@param clipping_mode constant clipping mode to set
---
---  gui.CLIPPING_MODE_NONE
---  gui.CLIPPING_MODE_STENCIL
---
function gui.set_clipping_mode(node, clipping_mode) end

---If node is set as an visible clipping node, it will be shown as well as clipping. Otherwise, it will only clip but not show visually.
---@param node node node to set clipping visibility for
---@param visible boolean true or false
function gui.set_clipping_visible(node, visible) end

---Sets the color of the supplied node. The components
---of the supplied vector3 or vector4 should contain the color channel values:
---Component
---Color value
---x
---Red value
---y
---Green value
---z
---Blue value
---w vector4
---Alpha value
---@param node node node to set the color for
---@param color vector3|vector4 new color
function gui.set_color(node, color) end

---Sets a node to the disabled or enabled state.
---Disabled nodes are not rendered and animations acting on them are not evaluated.
---@param node node node to be enabled/disabled
---@param enabled boolean whether the node should be enabled or not
function gui.set_enabled(node, enabled) end

---Sets the rotation of the supplied node.
---The rotation is expressed in degree Euler angles.
---@param node node node to set the rotation for
---@param rotation vector3|vector4 new rotation
function gui.set_euler(node, rotation) end

---Set the sector angle of a pie node.
---@param node node node to set the fill angle for
---@param angle number sector angle
function gui.set_fill_angle(node, angle) end

---This is only useful nodes with flipbook animations. The cursor is normalized.
---@param node node node to set the cursor for
---@param cursor number cursor value
function gui.set_flipbook_cursor(node, cursor) end

---This is only useful nodes with flipbook animations. Sets the playback rate of the flipbook animation on a node. Must be positive.
---@param node node node to set the cursor for
---@param playback_rate number playback rate
function gui.set_flipbook_playback_rate(node, playback_rate) end

---This is only useful for text nodes.
---The font must be mapped to the gui scene in the gui editor.
---@param node node node for which to set the font
---@param font string|hash font id
function gui.set_font(node, font) end

---Set the id of the specicied node to a new value.
---Nodes created with the gui.new_*_node() functions get
---an empty id. This function allows you to give dynamically
---created nodes an id.
--- No checking is done on the uniqueness of supplied ids.
---It is up to you to make sure you use unique ids.
---@param node node node to set the id for
---@param id string|hash id to set
function gui.set_id(node, id) end

---sets the node inherit alpha state
---@param node node node from which to set the inherit alpha state
---@param inherit_alpha boolean true or false
function gui.set_inherit_alpha(node, inherit_alpha) end

---Sets the inner radius of a pie node.
---The radius is defined along the x-axis.
---@param node node node to set the inner radius for
---@param radius number inner radius
function gui.set_inner_radius(node, radius) end

---The layer must be mapped to the gui scene in the gui editor.
---@param node node node for which to set the layer
---@param layer string|hash layer id
function gui.set_layer(node, layer) end

---Sets the leading value for a text node. This value is used to
---scale the line spacing of text.
---@param node node node for which to set the leading
---@param leading number a scaling value for the line spacing (default=1)
function gui.set_leading(node, leading) end

---Sets the line-break mode on a text node.
---This is only useful for text nodes.
---@param node node node to set line-break for
---@param line_break boolean true or false
function gui.set_line_break(node, line_break) end

---Set the material on a node. The material must be mapped to the gui scene in the gui editor,
---and assigning a material is supported for all node types. To set the default material that
---is assigned to the gui scene node, use gui.reset_material(node_id) instead.
---@param node node node to set material for
---@param material string|hash material id
function gui.set_material(node, material) end

---Sets the outer bounds mode for a pie node.
---@param node node node for which to set the outer bounds mode
---@param bounds_mode constant the outer bounds mode of the pie node:
---
---gui.PIEBOUNDS_RECTANGLE
---gui.PIEBOUNDS_ELLIPSE
---
function gui.set_outer_bounds(node, bounds_mode) end

---Sets the outline color of the supplied node.
---See gui.set_color for info how vectors encode color values.
---@param node node node to set the outline color for
---@param color vector3|vector4 new outline color
function gui.set_outline(node, color) end

---Sets the parent node of the specified node.
---@param node node node for which to set its parent
---@param parent node|nil parent node to set
---@param keep_scene_transform boolean|nil optional flag to make the scene position being perserved
function gui.set_parent(node, parent, keep_scene_transform) end

---Set the paricle fx for a gui node
---@param node node node to set particle fx for
---@param particlefx hash|string particle fx id
function gui.set_particlefx(node, particlefx) end

---Sets the number of generated vertices around the perimeter of a pie node.
---@param node node pie node
---@param vertices number vertex count
function gui.set_perimeter_vertices(node, vertices) end

---The pivot specifies how the node is drawn and rotated from its position.
---@param node node node to set pivot for
---@param pivot constant pivot constant
---
---  gui.PIVOT_CENTER
---  gui.PIVOT_N
---  gui.PIVOT_NE
---  gui.PIVOT_E
---  gui.PIVOT_SE
---  gui.PIVOT_S
---  gui.PIVOT_SW
---  gui.PIVOT_W
---  gui.PIVOT_NW
---
function gui.set_pivot(node, pivot) end

---Sets the position of the supplied node.
---@param node node node to set the position for
---@param position vector3|vector4 new position
function gui.set_position(node, position) end

---Set the order number for the current GUI scene.
---The number dictates the sorting of the "gui" render predicate,
---in other words in which order the scene will be rendered in relation
---to other currently rendered GUI scenes.
---The number must be in the range 0 to 15.
---@param order number rendering order (0-15)
function gui.set_render_order(order) end

---Sets the rotation of the supplied node.
---The rotation is expressed as a quaternion
---@param node node node to set the rotation for
---@param rotation quaternion|vector4 new rotation
function gui.set_rotation(node, rotation) end

---Sets the scaling of the supplied node.
---@param node node node to set the scale for
---@param scale vector3|vector4 new scale
function gui.set_scale(node, scale) end

---Set the screen position to the supplied node
---@param node node node to set the screen position to
---@param screen_position vector3 screen position
function gui.set_screen_position(node, screen_position) end

---Sets the shadow color of the supplied node.
---See gui.set_color for info how vectors encode color values.
---@param node node node to set the shadow color for
---@param color vector3|vector4 new shadow color
function gui.set_shadow(node, color) end

---Sets the size of the supplied node.
--- You can only set size on nodes with size mode set to SIZE_MODE_MANUAL
---@param node node node to set the size for
---@param size vector3|vector4 new size
function gui.set_size(node, size) end

---Sets the size mode of a node.
---The size mode defines how the node will adjust itself in size. Automatic
---size mode alters the node size based on the node's content. Automatic size
---mode works for Box nodes and Pie nodes which will both adjust their size
---to match the assigned image. Particle fx and Text nodes will ignore
---any size mode setting.
---@param node node node to set size mode for
---@param size_mode constant size mode to set
---
---gui.SIZE_MODE_MANUAL
---gui.SIZE_MODE_AUTO
---
function gui.set_size_mode(node, size_mode) end

---Set the slice9 configuration values for the node.
---@param node node node to manipulate
---@param values vector4 new values
function gui.set_slice9(node, values) end

---Set the text value of a text node. This is only useful for text nodes.
---@param node node node to set text for
---@param text string|number text to set
function gui.set_text(node, text) end

---Set the texture on a box or pie node. The texture must be mapped to
---the gui scene in the gui editor. The function points out which texture
---the node should render from. If the texture is an atlas, further
---information is needed to select which image/animation in the atlas
---to render. In such cases, use gui.play_flipbook() in
---addition to this function.
---@param node node node to set texture for
---@param texture string|hash texture id
function gui.set_texture(node, texture) end

---Set the texture buffer data for a dynamically created texture.
---@param texture string|hash texture id
---@param width number texture width
---@param height number texture height
---@param type string|constant texture type
---
---  "rgb" - RGB
---  "rgba" - RGBA
---  "l" - LUMINANCE
---
---@param buffer string texture data
---@param flip boolean flip texture vertically
---@return boolean success setting the data was successful
function gui.set_texture_data(texture, width, height, type, buffer, flip) end

---Sets the tracking value of a text node. This value is used to
---adjust the vertical spacing of characters in the text.
---@param node node node for which to set the tracking
---@param tracking number a scaling number for the letter spacing (default=0)
function gui.set_tracking(node, tracking) end

---Set if a node should be visible or not. Only visible nodes are rendered.
---@param node node node to be visible or not
---@param visible boolean whether the node should be visible or not
function gui.set_visible(node, visible) end

---The x-anchor specifies how the node is moved when the game is run in a different resolution.
---@param node node node to set x-anchor for
---@param anchor constant anchor constant
---
---gui.ANCHOR_NONE
---gui.ANCHOR_LEFT
---gui.ANCHOR_RIGHT
---
function gui.set_xanchor(node, anchor) end

---The y-anchor specifies how the node is moved when the game is run in a different resolution.
---@param node node node to set y-anchor for
---@param anchor constant anchor constant
---
---gui.ANCHOR_NONE
---gui.ANCHOR_TOP
---gui.ANCHOR_BOTTOM
---
function gui.set_yanchor(node, anchor) end

---Shows the on-display touch keyboard.
---The specified type of keyboard is displayed if it is available on
---the device.
---This function is only available on iOS and Android.  .
---@param type constant keyboard type
---
---gui.KEYBOARD_TYPE_DEFAULT
---gui.KEYBOARD_TYPE_EMAIL
---gui.KEYBOARD_TYPE_NUMBER_PAD
---gui.KEYBOARD_TYPE_PASSWORD
---
---@param autoclose boolean if the keyboard should automatically close when clicking outside
function gui.show_keyboard(type, autoclose) end

---Stops the particle fx for a gui node
---@param node node node to stop particle fx for
---@param options { clear:boolean|nil }|nil options when stopping the particle fx. Supported options:
---
---boolean clear: instantly clear spawned particles
---
function gui.stop_particlefx(node, options) end



return gui