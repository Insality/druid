--[[
  Generated with github.com/astrochili/defold-annotations
  Defold 1.8.0

  Image API documentation

  Functions for creating image objects.
--]]

---@diagnostic disable: lowercase-global
---@diagnostic disable: missing-return
---@diagnostic disable: duplicate-doc-param
---@diagnostic disable: duplicate-set-field

---@class defold_api.image
image = {}

---luminance image type
image.TYPE_LUMINANCE = nil

---luminance image type
image.TYPE_LUMINANCE_ALPHA = nil

---RGB image type
image.TYPE_RGB = nil

---RGBA image type
image.TYPE_RGBA = nil

---Load image (PNG or JPEG) from buffer.
---@param buffer string image data buffer
---@param options table|nil An optional table containing parameters for loading the image. Supported entries:
---
---premultiply_alpha
---boolean True if alpha should be premultiplied into the color components. Defaults to false.
---flip_vertically
---boolean True if the image contents should be flipped vertically. Defaults to false.
---
---@return { width:number, height:number, type:constant, buffer:string }|nil image object or nil if loading fails. The object is a table with the following fields:
---
---number width: image width
---number height: image height
---constant type: image type
---image.TYPE_RGB
---image.TYPE_RGBA
---image.TYPE_LUMINANCE
---image.TYPE_LUMINANCE_ALPHA
---
---
---string buffer: the raw image data
---
function image.load(buffer, options) end

---Load image (PNG or JPEG) from a string buffer.
---@param buffer string image data buffer
---@param options table|nil An optional table containing parameters for loading the image. Supported entries:
---
---premultiply_alpha
---boolean True if alpha should be premultiplied into the color components. Defaults to false.
---flip_vertically
---boolean True if the image contents should be flipped vertically. Defaults to false.
---
---@return { width:number, height:number, type:constant, buffer:buffer_data }|nil image object or nil if loading fails. The object is a table with the following fields:
---
---number width: image width
---number height: image height
---constant type: image type
---image.TYPE_RGB
---image.TYPE_RGBA
---image.TYPE_LUMINANCE
---image.TYPE_LUMINANCE_ALPHA
---
---
---buffer buffer: the script buffer that holds the decompressed image data. See buffer.create how to use the buffer.
---
function image.load_buffer(buffer, options) end

return image