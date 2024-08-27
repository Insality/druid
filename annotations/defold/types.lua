--[[
  Generated with github.com/astrochili/defold-annotations
  Defold 1.8.0

  Known classes and aliases used in the Defold API
--]]

---@diagnostic disable: lowercase-global
---@diagnostic disable: missing-return
---@diagnostic disable: duplicate-doc-param
---@diagnostic disable: duplicate-set-field

---@class matrix4
---@field c0 vector4
---@field c1 vector4
---@field c2 vector4
---@field c3 vector4
---@field m00 number
---@field m01 number
---@field m02 number
---@field m03 number
---@field m10 number
---@field m11 number
---@field m12 number
---@field m13 number
---@field m20 number
---@field m21 number
---@field m22 number
---@field m23 number
---@field m30 number
---@field m31 number
---@field m32 number
---@field m33 number

---@class physics.raycast_response
---@field fraction number
---@field group hash
---@field id hash
---@field normal vector3
---@field position vector3
---@field request_id number

---@class resource.animation
---@field flip_horizontal boolean
---@field flip_vertical boolean
---@field fps integer
---@field frame_end integer
---@field frame_start integer
---@field height integer
---@field id string
---@field playback constant
---@field width integer

---@class resource.atlas
---@field animations resource.animation[]
---@field geometries resource.geometry[]
---@field texture string|hash

---@class resource.geometry
---@field id string
---@field indices number[]
---@field uvs number[]
---@field vertices number[]

---@class socket.dns
socket.dns = {}

---@class url
---@field fragment hash
---@field path hash
---@field socket hash

---@class vector3
---@field x number
---@field y number
---@field z number
---@operator add(vector3): vector3
---@operator mul(number): vector3
---@operator sub(vector3): vector3
---@operator unm: vector3

---@class vector4
---@field w number
---@field x number
---@field y number
---@field z number
---@operator add(vector4): vector4
---@operator mul(number): vector4
---@operator sub(vector4): vector4
---@operator unm: vector4

---@alias array table
---@alias b2Body userdata
---@alias b2BodyType number
---@alias b2World userdata
---@alias bool boolean
---@alias buffer_data userdata
---@alias buffer_stream userdata
---@alias constant userdata
---@alias constant_buffer userdata
---@alias float number
---@alias hash userdata
---@alias node userdata
---@alias quaternion vector4
---@alias render_predicate userdata
---@alias render_target userdata
---@alias resource_data userdata
---@alias resource_handle number|userdata
---@alias socket_client userdata
---@alias socket_master userdata
---@alias socket_unconnected userdata