--[[
  Generated with github.com/astrochili/defold-annotations
  Defold 1.8.0

  Model API documentation
--]]

---@diagnostic disable: lowercase-global
---@diagnostic disable: missing-return
---@diagnostic disable: duplicate-doc-param
---@diagnostic disable: duplicate-set-field

---@class defold_api.model
model = {}

---Cancels all animation on a model component.
---@param url string|hash|url the model for which to cancel the animation
function model.cancel(url) end

---Gets the id of the game object that corresponds to a model skeleton bone.
---The returned game object can be used for parenting and transform queries.
---This function has complexity O(n), where n is the number of bones in the model skeleton.
---Game objects corresponding to a model skeleton bone can not be individually deleted.
---@param url string|hash|url the model to query
---@param bone_id string|hash id of the corresponding bone
---@return hash id id of the game object
function model.get_go(url, bone_id) end

---Get the enabled state of a mesh
---@param url string|hash|url the model
---@param mesh_id string|hash|url the id of the mesh
---@return boolean enabled true if the mesh is visible, false otherwise
function model.get_mesh_enabled(url, mesh_id) end

---Plays an animation on a model component with specified playback
---mode and parameters.
---An optional completion callback function can be provided that will be called when
---the animation has completed playing. If no function is provided,
---a model_animation_done message is sent to the script that started the animation.
--- The callback is not called (or message sent) if the animation is
---cancelled with model.cancel. The callback is called (or message sent) only for
---animations that play with the following playback modes:
---go.PLAYBACK_ONCE_FORWARD
---go.PLAYBACK_ONCE_BACKWARD
---go.PLAYBACK_ONCE_PINGPONG
---@param url string|hash|url the model for which to play the animation
---@param anim_id string|hash id of the animation to play
---@param playback constant playback mode of the animation
---
---go.PLAYBACK_ONCE_FORWARD
---go.PLAYBACK_ONCE_BACKWARD
---go.PLAYBACK_ONCE_PINGPONG
---go.PLAYBACK_LOOP_FORWARD
---go.PLAYBACK_LOOP_BACKWARD
---go.PLAYBACK_LOOP_PINGPONG
---
---@param play_properties { blend_duration:number|nil, offset:number|nil, playback_rate:number|nil}|nil optional table with properties
---Play properties table:
---
---blend_duration
---number Duration of a linear blend between the current and new animation.
---offset
---number The normalized initial value of the animation cursor when the animation starts playing.
---playback_rate
---number The rate with which the animation will be played. Must be positive.
---
---@param complete_function fun(self, message_id, message, sender)|nil function to call when the animation has completed.
---
---self
---object The current object.
---message_id
---hash The name of the completion message, "model_animation_done".
---message
---table Information about the completion:
---
---
---hash animation_id - the animation that was completed.
---constant playback - the playback mode for the animation.
---
---
---sender
---url The invoker of the callback: the model component.
---
function model.play_anim(url, anim_id, playback, play_properties, complete_function) end

---Enable or disable visibility of a mesh
---@param url string|hash|url the model
---@param mesh_id string|hash|url the id of the mesh
---@param enabled boolean true if the mesh should be visible, false if it should be hideen
function model.set_mesh_enabled(url, mesh_id, enabled) end

return model