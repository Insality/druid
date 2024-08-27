--[[
  Generated with github.com/astrochili/defold-annotations
  Defold 1.8.0

  Collision object physics API documentation
--]]

---@diagnostic disable: lowercase-global
---@diagnostic disable: missing-return
---@diagnostic disable: duplicate-doc-param
---@diagnostic disable: duplicate-set-field

---@class defold_api.physics
physics = {}

---The following properties are available when connecting a joint of JOINT_TYPE_FIXED type:
physics.JOINT_TYPE_FIXED = nil

---The following properties are available when connecting a joint of JOINT_TYPE_HINGE type:
physics.JOINT_TYPE_HINGE = nil

---The following properties are available when connecting a joint of JOINT_TYPE_SLIDER type:
physics.JOINT_TYPE_SLIDER = nil

---The following properties are available when connecting a joint of JOINT_TYPE_SPRING type:
physics.JOINT_TYPE_SPRING = nil

---The following properties are available when connecting a joint of JOINT_TYPE_WELD type:
physics.JOINT_TYPE_WELD = nil

---The following properties are available when connecting a joint of JOINT_TYPE_WHEEL type:
physics.JOINT_TYPE_WHEEL = nil

physics.SHAPE_TYPE_SPHERE = nil

physics.SHAPE_TYPE_BOX = nil

physics.SHAPE_TYPE_CAPSULE = nil

physics.SHAPE_TYPE_HULL = nil

---Create a physics joint between two collision object components.
---Note: Currently only supported in 2D physics.
---@param joint_type number the joint type
---@param collisionobject_a string|hash|url first collision object
---@param joint_id string|hash id of the joint
---@param position_a vector3 local position where to attach the joint on the first collision object
---@param collisionobject_b string|hash|url second collision object
---@param position_b vector3 local position where to attach the joint on the second collision object
---@param properties table|nil optional joint specific properties table
---See each joint type for possible properties field. The one field that is accepted for all joint types is:
---- boolean collide_connected: Set this flag to true if the attached bodies should collide.
function physics.create_joint(joint_type, collisionobject_a, joint_id, position_a, collisionobject_b, position_b, properties) end

---Destroy an already physics joint. The joint has to be created before a
---destroy can be issued.
---Note: Currently only supported in 2D physics.
---@param collisionobject string|hash|url collision object where the joint exist
---@param joint_id string|hash id of the joint
function physics.destroy_joint(collisionobject, joint_id) end

---Get the gravity in runtime. The gravity returned is not global, it will return
---the gravity for the collection that the function is called from.
---Note: For 2D physics the z component will always be zero.
---@return vector3 gravity gravity vector of collection
function physics.get_gravity() end

---Returns the group name of a collision object as a hash.
---@param url string|hash|url the collision object to return the group of.
---@return hash group hash value of the group.
---local function check_is_enemy()
---    local group = physics.get_group("#collisionobject")
---    return group == hash("enemy")
---end
---
function physics.get_group(url) end

---Get a table for properties for a connected joint. The joint has to be created before
---properties can be retrieved.
---Note: Currently only supported in 2D physics.
---@param collisionobject string|hash|url collision object where the joint exist
---@param joint_id string|hash id of the joint
---@return { collide_connected:boolean|nil } properties properties table. See the joint types for what fields are available, the only field available for all types is:
---
---boolean collide_connected: Set this flag to true if the attached bodies should collide.
---
function physics.get_joint_properties(collisionobject, joint_id) end

---Get the reaction force for a joint. The joint has to be created before
---the reaction force can be calculated.
---Note: Currently only supported in 2D physics.
---@param collisionobject string|hash|url collision object where the joint exist
---@param joint_id string|hash id of the joint
---@return vector3 force reaction force for the joint
function physics.get_joint_reaction_force(collisionobject, joint_id) end

---Get the reaction torque for a joint. The joint has to be created before
---the reaction torque can be calculated.
---Note: Currently only supported in 2D physics.
---@param collisionobject string|hash|url collision object where the joint exist
---@param joint_id string|hash id of the joint
---@return float torque the reaction torque on bodyB in N*m.
function physics.get_joint_reaction_torque(collisionobject, joint_id) end

---Returns true if the specified group is set in the mask of a collision
---object, false otherwise.
---@param url string|hash|url the collision object to check the mask of.
---@param group string the name of the group to check for.
---@return boolean maskbit boolean value of the maskbit. 'true' if present, 'false' otherwise.
---local function is_invincible()
---    -- check if the collisionobject would collide with the "bullet" group
---    local invincible = physics.get_maskbit("#collisionobject", "bullet")
---    return invincible
---end
---
function physics.get_maskbit(url, group) end

---Gets collision shape data from a collision object
---@param url string|hash|url the collision object.
---@param shape string|hash the name of the shape to get data for.
---@return { type:number|nil, diameter:number|nil, dimensions:vector3|nil, height:number|nil } table A table containing meta data about the physics shape
---
---type
---number The shape type. Supported values:
---
---
---physics.SHAPE_TYPE_SPHERE
---physics.SHAPE_TYPE_BOX
---physics.SHAPE_TYPE_CAPSULE Only supported for 3D physics
---physics.SHAPE_TYPE_HULL
---
---The returned table contains different fields depending on which type the shape is.
---If the shape is a sphere:
---
---diameter
---number the diameter of the sphere shape
---
---If the shape is a box:
---
---dimensions
---vector3 a vmath.vector3 of the box dimensions
---
---If the shape is a capsule:
---
---diameter
---number the diameter of the capsule poles
---height
---number the height of the capsule
---
---local function get_shape_meta()
---    local sphere = physics.get_shape("#collisionobject", "my_sphere_shape")
---    -- returns a table with sphere.diameter
---    return sphere
---end
---
function physics.get_shape(url, shape) end

---Ray casts are used to test for intersections against collision objects in the physics world.
---Collision objects of types kinematic, dynamic and static are tested against. Trigger objects
---do not intersect with ray casts.
---Which collision objects to hit is filtered by their collision groups and can be configured
---through groups.
---@param from vector3 the world position of the start of the ray
---@param to vector3 the world position of the end of the ray
---@param groups table a lua table containing the hashed groups for which to test collisions against
---@param options { all:boolean|nil }|nil a lua table containing options for the raycast.
---
---all
---boolean Set to true to return all ray cast hits. If false, it will only return the closest hit.
---
---@return physics.raycast_response[]|physics.raycast_response|nil result It returns a list. If missed it returns nil. See ray_cast_response for details on the returned values.
function physics.raycast(from, to, groups, options) end

---Ray casts are used to test for intersections against collision objects in the physics world.
---Collision objects of types kinematic, dynamic and static are tested against. Trigger objects
---do not intersect with ray casts.
---Which collision objects to hit is filtered by their collision groups and can be configured
---through groups.
---The actual ray cast will be performed during the physics-update.
---If an object is hit, the result will be reported via a ray_cast_response message.
---If there is no object hit, the result will be reported via a ray_cast_missed message.
---@param from vector3 the world position of the start of the ray
---@param to vector3 the world position of the end of the ray
---@param groups table a lua table containing the hashed groups for which to test collisions against
---@param request_id number|nil a number between [0,-255]. It will be sent back in the response for identification, 0 by default
function physics.raycast_async(from, to, groups, request_id) end

---Set the gravity in runtime. The gravity change is not global, it will only affect
---the collection that the function is called from.
---Note: For 2D physics the z component of the gravity vector will be ignored.
---@param gravity vector3 the new gravity vector
function physics.set_gravity(gravity) end

---Updates the group property of a collision object to the specified
---string value. The group name should exist i.e. have been used in
---a collision object in the editor.
---@param url string|hash|url the collision object affected.
---@param group string the new group name to be assigned.
---local function change_collision_group()
---     physics.set_group("#collisionobject", "enemy")
---end
---
function physics.set_group(url, group) end

---Flips the collision shapes horizontally for a collision object
---@param url string|hash|url the collision object that should flip its shapes
---@param flip boolean true if the collision object should flip its shapes, false if not
function physics.set_hflip(url, flip) end

---Updates the properties for an already connected joint. The joint has to be created before
---properties can be changed.
---Note: Currently only supported in 2D physics.
---@param collisionobject string|hash|url collision object where the joint exist
---@param joint_id string|hash id of the joint
---@param properties table joint specific properties table
---Note: The collide_connected field cannot be updated/changed after a connection has been made.
function physics.set_joint_properties(collisionobject, joint_id, properties) end

---sets a physics world event listener. If a function is set, physics messages will no longer be sent.
---@param callback fun(self, event, data)|nil A callback that receives information about all the physics interactions in this physics world.
---
---self
---object The calling script
---event
---constant The type of event. Can be one of these messages:
---
---
---contact_point_event
---collision_event
---trigger_event
---ray_cast_response
---ray_cast_missed
---
---
---data
---table The callback value data is a table that contains event-related data. See the documentation for details on the messages.
---
function physics.set_listener(callback) end

---Sets or clears the masking of a group (maskbit) in a collision object.
---@param url string|hash|url the collision object to change the mask of.
---@param group string the name of the group (maskbit) to modify in the mask.
---@param maskbit boolean boolean value of the new maskbit. 'true' to enable, 'false' to disable.
---local function make_invincible()
---    -- no longer collide with the "bullet" group
---    physics.set_maskbit("#collisionobject", "bullet", false)
---end
---
function physics.set_maskbit(url, group, maskbit) end

---Sets collision shape data for a collision object. Please note that updating data in 3D
---can be quite costly for box and capsules. Because of the physics engine, the cost
---comes from having to recreate the shape objects when certain shapes needs to be updated.
---@param url string|hash|url the collision object.
---@param shape string|hash the name of the shape to get data for.
---@param table { diameter:number|nil, dimensions:vector3|nil, height:number|nil } the shape data to update the shape with.
---See physics.get_shape for a detailed description of each field in the data table.
---local function set_shape_data()
---    -- set capsule shape data
---    local data = {}
---    data.diameter = 10
---    data.height = 20
---    physics.set_shape("#collisionobject", "my_capsule_shape", data)
---
---    -- set sphere shape data
---    data = {}
---    data.diameter = 10
---    physics.set_shape("#collisionobject", "my_sphere_shape", data)
---
---    -- set box shape data
---    data = {}
---    data.dimensions = vmath.vector3(10, 10, 5)
---    physics.set_shape("#collisionobject", "my_box_shape", data)
---end
---
function physics.set_shape(url, shape, table) end

---Flips the collision shapes vertically for a collision object
---@param url string|hash|url the collision object that should flip its shapes
---@param flip boolean true if the collision object should flip its shapes, false if not
function physics.set_vflip(url, flip) end

---The function recalculates the density of each shape based on the total area of all shapes and the specified mass, then updates the mass of the body accordingly.
---Note: Currently only supported in 2D physics.
---@param collisionobject string|hash|url the collision object whose mass needs to be updated.
---@param mass number the new mass value to set for the collision object.
function physics.update_mass(collisionobject, mass) end

---Collision objects tend to fall asleep when inactive for a small period of time for
---efficiency reasons. This function wakes them up.
---@param url string|hash|url the collision object to wake.
---function on_input(self, action_id, action)
---    if action_id == hash("test") and action.pressed then
---        physics.wakeup("#collisionobject")
---    end
---end
---
function physics.wakeup(url) end

return physics