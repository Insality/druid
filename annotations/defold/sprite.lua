--[[
  Generated with github.com/astrochili/defold-annotations
  Defold 1.8.0

  Sprite API documentation
--]]

---@diagnostic disable: lowercase-global
---@diagnostic disable: missing-return
---@diagnostic disable: duplicate-doc-param
---@diagnostic disable: duplicate-set-field

---@class defold_api.sprite
sprite = {}

---Play an animation on a sprite component from its tile set
---An optional completion callback function can be provided that will be called when
---the animation has completed playing. If no function is provided,
---a animation_done message is sent to the script that started the animation.
---@param url string|hash|url the sprite that should play the animation
---@param id string|hash hashed id of the animation to play
---@param complete_function fun(self, message_id, message, sender)|nil function to call when the animation has completed.
---
---self
---object The current object.
---message_id
---hash The name of the completion message, "animation_done".
---message
---table Information about the completion:
---
---
---number current_tile - the current tile of the sprite.
---hash id - id of the animation that was completed.
---
---
---sender
---url The invoker of the callback: the sprite component.
---
---@param play_properties table|nil optional table with properties:
---
---offset
---number the normalized initial value of the animation cursor when the animation starts playing.
---playback_rate
---number the rate with which the animation will be played. Must be positive.
---
function sprite.play_flipbook(url, id, complete_function, play_properties) end

---Sets horizontal flipping of the provided sprite's animations.
---The sprite is identified by its URL.
---If the currently playing animation is flipped by default, flipping it again will make it appear like the original texture.
---@param url string|hash|url the sprite that should flip its animations
---@param flip boolean true if the sprite should flip its animations, false if not
function sprite.set_hflip(url, flip) end

---Sets vertical flipping of the provided sprite's animations.
---The sprite is identified by its URL.
---If the currently playing animation is flipped by default, flipping it again will make it appear like the original texture.
---@param url string|hash|url the sprite that should flip its animations
---@param flip boolean true if the sprite should flip its animations, false if not
function sprite.set_vflip(url, flip) end

return sprite