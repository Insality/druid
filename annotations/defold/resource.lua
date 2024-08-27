--[[
  Generated with github.com/astrochili/defold-annotations
  Defold 1.8.0

  Resource API documentation

  Functions and constants to access resources.
--]]

---@diagnostic disable: lowercase-global
---@diagnostic disable: missing-return
---@diagnostic disable: duplicate-doc-param
---@diagnostic disable: duplicate-set-field

---@class defold_api.resource
resource = {}

---BASIS_UASTC compression type
resource.COMPRESSION_TYPE_BASIS_UASTC = nil

---COMPRESSION_TYPE_DEFAULT compression type
resource.COMPRESSION_TYPE_DEFAULT = nil

---luminance type texture format
resource.TEXTURE_FORMAT_LUMINANCE = nil

---R16F type texture format
resource.TEXTURE_FORMAT_R16F = nil

---R32F type texture format
resource.TEXTURE_FORMAT_R32F = nil

---RG16F type texture format
resource.TEXTURE_FORMAT_RG16F = nil

---RG32F type texture format
resource.TEXTURE_FORMAT_RG32F = nil

---RGB type texture format
resource.TEXTURE_FORMAT_RGB = nil

---RGB16F type texture format
resource.TEXTURE_FORMAT_RGB16F = nil

---RGB32F type texture format
resource.TEXTURE_FORMAT_RGB32F = nil

---RGBA type texture format
resource.TEXTURE_FORMAT_RGBA = nil

---RGBA16F type texture format
resource.TEXTURE_FORMAT_RGBA16F = nil

---RGBA32F type texture format
resource.TEXTURE_FORMAT_RGBA32F = nil

---RGBA_ASTC_4x4 type texture format
resource.TEXTURE_FORMAT_RGBA_ASTC_4x4 = nil

---RGBA_BC3 type texture format
resource.TEXTURE_FORMAT_RGBA_BC3 = nil

---RGBA_BC7 type texture format
resource.TEXTURE_FORMAT_RGBA_BC7 = nil

---RGBA_ETC2 type texture format
resource.TEXTURE_FORMAT_RGBA_ETC2 = nil

---RGBA_PVRTC_2BPPV1 type texture format
resource.TEXTURE_FORMAT_RGBA_PVRTC_2BPPV1 = nil

---RGBA_PVRTC_4BPPV1 type texture format
resource.TEXTURE_FORMAT_RGBA_PVRTC_4BPPV1 = nil

---RGB_BC1 type texture format
resource.TEXTURE_FORMAT_RGB_BC1 = nil

---RGB_ETC1 type texture format
resource.TEXTURE_FORMAT_RGB_ETC1 = nil

---RGB_PVRTC_2BPPV1 type texture format
resource.TEXTURE_FORMAT_RGB_PVRTC_2BPPV1 = nil

---RGB_PVRTC_4BPPV1 type texture format
resource.TEXTURE_FORMAT_RGB_PVRTC_4BPPV1 = nil

---RG_BC5 type texture format
resource.TEXTURE_FORMAT_RG_BC5 = nil

---R_BC4 type texture format
resource.TEXTURE_FORMAT_R_BC4 = nil

---2D texture type
resource.TEXTURE_TYPE_2D = nil

---2D Array texture type
resource.TEXTURE_TYPE_2D_ARRAY = nil

---Cube map texture type
resource.TEXTURE_TYPE_CUBE_MAP = nil

---Constructor-like function with two purposes:
---Load the specified resource as part of loading the script
---Return a hash to the run-time version of the resource
--- This function can only be called within go.property function calls.
---@param path string|nil optional resource path string to the resource
---@return hash path a path hash to the binary version of the resource
function resource.atlas(path) end

---Constructor-like function with two purposes:
---Load the specified resource as part of loading the script
---Return a hash to the run-time version of the resource
--- This function can only be called within go.property function calls.
---@param path string|nil optional resource path string to the resource
---@return hash path a path hash to the binary version of the resource
function resource.buffer(path) end

---This function creates a new atlas resource that can be used in the same way as any atlas created during build time.
---The path used for creating the atlas must be unique, trying to create a resource at a path that is already
---registered will trigger an error. If the intention is to instead modify an existing atlas, use the resource.set_atlas
---function. Also note that the path to the new atlas resource must have a '.texturesetc' extension,
---meaning "/path/my_atlas" is not a valid path but "/path/my_atlas.texturesetc" is.
---When creating the atlas, at least one geometry and one animation is required, and an error will be
---raised if these requirements are not met. A reference to the resource will be held by the collection
---that created the resource and will automatically be released when that collection is destroyed.
---Note that releasing a resource essentially means decreasing the reference count of that resource,
---and not necessarily that it will be deleted.
---@param path string The path to the resource.
---@param table resource.atlas A table containing info about how to create the atlas. Supported entries:
---
---
---
---texture
---string | hash the path to the texture resource, e.g "/main/my_texture.texturec"
---
---
---
---
---animations
---table a list of the animations in the atlas. Supports the following fields:
---
---
---
---
---id
---string the id of the animation, used in e.g sprite.play_animation
---
---
---
---
---width
---integer the width of the animation
---
---
---
---
---height
---integer the height of the animation
---
---
---
---
---frame_start
---integer index to the first geometry of the animation. Indices are lua based and must be in the range of 1 ..  in atlas.
---
---
---
---
---frame_end
---integer index to the last geometry of the animation (non-inclusive). Indices are lua based and must be in the range of 1 ..  in atlas.
---
---
---
---
---playback
---constant optional playback mode of the animation, the default value is go.PLAYBACK_ONCE_FORWARD
---
---
---
---
---fps
---integer optional fps of the animation, the default value is 30
---
---
---
---
---flip_vertical
---boolean optional flip the animation vertically, the default value is false
---
---
---
---
---flip_horizontal
---boolean optional flip the animation horizontally, the default value is false
---
---
---
---
---geometries
---table A list of the geometries that should map to the texture data. Supports the following fields:
---
---
---
---
---id
---string The name of the geometry. Used when matching animations between multiple atlases
---
---
---
---
---vertices
---table a list of the vertices in texture space of the geometry in the form {px0, py0, px1, py1, ..., pxn, pyn}
---
---
---
---
---uvs
---table a list of the uv coordinates in texture space of the geometry in the form of {u0, v0, u1, v1, ..., un, vn}
---
---
---
---
---indices
---table a list of the indices of the geometry in the form {i0, i1, i2, ..., in}. Each tripe in the list represents a triangle.
---
---
---
---@return hash path Returns the atlas resource path
function resource.create_atlas(path, table) end

---This function creates a new buffer resource that can be used in the same way as any buffer created during build time.
---The function requires a valid buffer created from either buffer.create or another pre-existing buffer resource.
---By default, the new resource will take ownership of the buffer lua reference, meaning the buffer will not automatically be removed
---when the lua reference to the buffer is garbage collected. This behaviour can be overruled by specifying 'transfer_ownership = false'
---in the argument table. If the new buffer resource is created from a buffer object that is created by another resource,
---the buffer object will be copied and the new resource will effectively own a copy of the buffer instead.
---Note that the path to the new resource must have the '.bufferc' extension, "/path/my_buffer" is not a valid path but "/path/my_buffer.bufferc" is.
---The path must also be unique, attempting to create a buffer with the same name as an existing resource will raise an error.
---@param path string The path to the resource.
---@param table { buffer:buffer_data, transfer_ownership:boolean|nil }|nil A table containing info about how to create the buffer. Supported entries:
---
---
---
---buffer
---buffer the buffer to bind to this resource
---
---
---
---
---transfer_ownership
---boolean optional flag to determine wether or not the resource should take over ownership of the buffer object (default true)
---
---
---
---@return hash path Returns the buffer resource path
function resource.create_buffer(path, table) end

---Creates a new texture resource that can be used in the same way as any texture created during build time.
---The path used for creating the texture must be unique, trying to create a resource at a path that is already
---registered will trigger an error. If the intention is to instead modify an existing texture, use the resource.set_texture
---function. Also note that the path to the new texture resource must have a '.texturec' extension,
---meaning "/path/my_texture" is not a valid path but "/path/my_texture.texturec" is.
---If the texture is created without a buffer, the pixel data will be blank.
---@param path string The path to the resource.
---@param table { type:number, width:number, height:number, format:number, max_mipmaps:number|nil, compression_type:number|nil} A table containing info about how to create the texture. Supported entries:
---
---type
---number The texture type. Supported values:
---
---
---resource.TEXTURE_TYPE_2D
---resource.TEXTURE_TYPE_CUBE_MAP
---
---
---width
---number The width of the texture (in pixels). Must be larger than 0.
---height
---number The width of the texture (in pixels). Must be larger than 0.
---format
---number The texture format, note that some of these formats might not be supported by the running device. Supported values:
---
---
---resource.TEXTURE_FORMAT_LUMINANCE
---resource.TEXTURE_FORMAT_RGB
---resource.TEXTURE_FORMAT_RGBA
---
---These constants might not be available on the device:
---
---resource.TEXTURE_FORMAT_RGB_PVRTC_2BPPV1
---resource.TEXTURE_FORMAT_RGB_PVRTC_4BPPV1
---resource.TEXTURE_FORMAT_RGBA_PVRTC_2BPPV1
---resource.TEXTURE_FORMAT_RGBA_PVRTC_4BPPV1
---resource.TEXTURE_FORMAT_RGB_ETC1
---resource.TEXTURE_FORMAT_RGBA_ETC2
---resource.TEXTURE_FORMAT_RGBA_ASTC_4x4
---resource.TEXTURE_FORMAT_RGB_BC1
---resource.TEXTURE_FORMAT_RGBA_BC3
---resource.TEXTURE_FORMAT_R_BC4
---resource.TEXTURE_FORMAT_RG_BC5
---resource.TEXTURE_FORMAT_RGBA_BC7
---resource.TEXTURE_FORMAT_RGB16F
---resource.TEXTURE_FORMAT_RGB32F
---resource.TEXTURE_FORMAT_RGBA16F
---resource.TEXTURE_FORMAT_RGBA32F
---resource.TEXTURE_FORMAT_R16F
---resource.TEXTURE_FORMAT_RG16F
---resource.TEXTURE_FORMAT_R32F
---resource.TEXTURE_FORMAT_RG32F
---
---You can test if the device supports these values by checking if a specific enum is nil or not:
---if resource.TEXTURE_FORMAT_RGBA16F ~= nil then
---    -- it is safe to use this format
---end
---
---
---
---max_mipmaps
---number optional max number of mipmaps. Defaults to zero, i.e no mipmap support
---compression_type
---number optional specify the compression type for the data in the buffer object that holds the texture data. Will only be used when a compressed buffer has been passed into the function.
---Creating an empty texture with no buffer data is not supported as a core feature. Defaults to resource.COMPRESSION_TYPE_DEFAULT, i.e no compression. Supported values:
---
---
---COMPRESSION_TYPE_DEFAULT
---COMPRESSION_TYPE_BASIS_UASTC
---
---@param buffer buffer_data optional buffer of precreated pixel data
---@return hash path The path to the resource.
function resource.create_texture(path, table, buffer) end

---Creates a new texture resource that can be used in the same way as any texture created during build time.
---The path used for creating the texture must be unique, trying to create a resource at a path that is already
---registered will trigger an error. If the intention is to instead modify an existing texture, use the resource.set_texture
---function. Also note that the path to the new texture resource must have a '.texturec' extension,
---meaning "/path/my_texture" is not a valid path but "/path/my_texture.texturec" is.
---If the texture is created without a buffer, the pixel data will be blank.
---The difference between the async version and resource.create_texture is that the texture data will be uploaded
---in a graphics worker thread. The function will return a resource immediately that contains a 1x1 blank texture which can be used
---immediately after the function call. When the new texture has been uploaded, the initial blank texture will be deleted and replaced with the
---new texture. Be careful when using the initial texture handle handle as it will not be valid after the upload has finished.
---@param path string The path to the resource.
---@param table { type:number, width:number, height:number, format:number, max_mipmaps:number|nil, compression_type:number|nil}
---A table containing info about how to create the texture. Supported entries:
---type
---number The texture type. Supported values:
---
---
---resource.TEXTURE_TYPE_2D
---resource.TEXTURE_TYPE_CUBE_MAP
---
---
---width
---number The width of the texture (in pixels). Must be larger than 0.
---height
---number The width of the texture (in pixels). Must be larger than 0.
---format
---number The texture format, note that some of these formats might not be supported by the running device. Supported values:
---
---
---resource.TEXTURE_FORMAT_LUMINANCE
---resource.TEXTURE_FORMAT_RGB
---resource.TEXTURE_FORMAT_RGBA
---
---These constants might not be available on the device:
---
---resource.TEXTURE_FORMAT_RGB_PVRTC_2BPPV1
---resource.TEXTURE_FORMAT_RGB_PVRTC_4BPPV1
---resource.TEXTURE_FORMAT_RGBA_PVRTC_2BPPV1
---resource.TEXTURE_FORMAT_RGBA_PVRTC_4BPPV1
---resource.TEXTURE_FORMAT_RGB_ETC1
---resource.TEXTURE_FORMAT_RGBA_ETC2
---resource.TEXTURE_FORMAT_RGBA_ASTC_4x4
---resource.TEXTURE_FORMAT_RGB_BC1
---resource.TEXTURE_FORMAT_RGBA_BC3
---resource.TEXTURE_FORMAT_R_BC4
---resource.TEXTURE_FORMAT_RG_BC5
---resource.TEXTURE_FORMAT_RGBA_BC7
---resource.TEXTURE_FORMAT_RGB16F
---resource.TEXTURE_FORMAT_RGB32F
---resource.TEXTURE_FORMAT_RGBA16F
---resource.TEXTURE_FORMAT_RGBA32F
---resource.TEXTURE_FORMAT_R16F
---resource.TEXTURE_FORMAT_RG16F
---resource.TEXTURE_FORMAT_R32F
---resource.TEXTURE_FORMAT_RG32F
---
---You can test if the device supports these values by checking if a specific enum is nil or not:
---if resource.TEXTURE_FORMAT_RGBA16F ~= nil then
---    -- it is safe to use this format
---end
---
---
---
---max_mipmaps
---number optional max number of mipmaps. Defaults to zero, i.e no mipmap support
---compression_type
---number optional specify the compression type for the data in the buffer object that holds the texture data. Will only be used when a compressed buffer has been passed into the function.
---Creating an empty texture with no buffer data is not supported as a core feature. Defaults to resource.COMPRESSION_TYPE_DEFAULT, i.e no compression. Supported values:
---
---
---COMPRESSION_TYPE_DEFAULT
---COMPRESSION_TYPE_BASIS_UASTC
---
---@param buffer buffer_data optional buffer of precreated pixel data
---@return hash path The path to the resource.
---@return resource_handle request_id The request id for the async request.
function resource.create_texture_async(path, table, buffer) end

---Constructor-like function with two purposes:
---Load the specified resource as part of loading the script
---Return a hash to the run-time version of the resource
--- This function can only be called within go.property function calls.
---@param path string|nil optional resource path string to the resource
---@return hash path a path hash to the binary version of the resource
function resource.font(path) end

---Returns the atlas data for an atlas
---@param path hash|string The path to the atlas resource
---@return resource.atlas data A table with the following entries:
---
---texture
---geometries
---animations
---
---See resource.set_atlas for a detailed description of each field
function resource.get_atlas(path) end

---gets the buffer from a resource
---@param path hash|string The path to the resource
---@return buffer_data buffer The resource buffer
function resource.get_buffer(path) end

---Gets render target info from a render target resource path or a render target handle
---@param path hash|string|resource_handle The path to the resource or a render target handle
---@return { handle:resource_handle, attachments:{ handle:resource_handle, width:number, height:number, depth:number, mipmaps:number, type:number, buffer_type:number }[] } table A table containing info about the render target:
---
---handle
---handle the opaque handle to the texture resource
---'attachments'
---table a table of attachments, where each attachment contains the following entries:
---handle
---handle the opaque handle to the texture resource
---width
---integer width of the texture
---height
---integer height of the texture
---depth
---integer depth of the texture (i.e 1 for a 2D texture and 6 for a cube map)
---mipmaps
---integer number of mipmaps of the texture
---type
---number The texture type. Supported values:
---
---
---resource.TEXTURE_TYPE_2D
---resource.TEXTURE_TYPE_CUBE_MAP
---resource.TEXTURE_TYPE_2D_ARRAY
---
---
---buffer_type
---number The attachment buffer type. Supported values:
---
---
---resource.BUFFER_TYPE_COLOR0
---resource.BUFFER_TYPE_COLOR1
---resource.BUFFER_TYPE_COLOR2
---resource.BUFFER_TYPE_COLOR3
---resource.BUFFER_TYPE_DEPTH
---resource.BUFFER_TYPE_STENCIL
---
function resource.get_render_target_info(path) end

---Gets the text metrics from a font
---@param url hash the font to get the (unscaled) metrics from
---@param text string text to measure
---@param options { width:number|nil, leading:number|nil, tracking:number|nil, line_break:boolean|nil}|nil A table containing parameters for the text. Supported entries:
---
---width
---integer The width of the text field. Not used if line_break is false.
---leading
---number The leading (default 1.0)
---tracking
---number The tracking (default 0.0)
---line_break
---boolean If the calculation should consider line breaks (default false)
---
---@return { width:number, height:number, max_ascent:number, max_descent:number } metrics a table with the following fields:
---
---width
---height
---max_ascent
---max_descent
---
function resource.get_text_metrics(url, text, options) end

---Gets texture info from a texture resource path or a texture handle
---@param path hash|string|resource_handle The path to the resource or a texture handle
---@return { handle:resource_handle, width:number, height:number, depth:number, mipmaps:number, type:number } table A table containing info about the texture:
---
---handle
---handle the opaque handle to the texture resource
---width
---integer width of the texture
---height
---integer height of the texture
---depth
---integer depth of the texture (i.e 1 for a 2D texture and 6 for a cube map)
---mipmaps
---integer number of mipmaps of the texture
---type
---number The texture type. Supported values:
---
---
---resource.TEXTURE_TYPE_2D
---resource.TEXTURE_TYPE_CUBE_MAP
---resource.TEXTURE_TYPE_2D_ARRAY
---
function resource.get_texture_info(path) end

---Loads the resource data for a specific resource.
---@param path string The path to the resource
---@return buffer_data buffer Returns the buffer stored on disc
function resource.load(path) end

---Constructor-like function with two purposes:
---Load the specified resource as part of loading the script
---Return a hash to the run-time version of the resource
--- This function can only be called within go.property function calls.
---@param path string|nil optional resource path string to the resource
---@return hash path a path hash to the binary version of the resource
function resource.material(path) end

---Release a resource.
--- This is a potentially dangerous operation, releasing resources currently being used can cause unexpected behaviour.
---@param path hash|string The path to the resource.
function resource.release(path) end

---Sets the resource data for a specific resource
---@param path string|hash The path to the resource
---@param buffer buffer_data The buffer of precreated data, suitable for the intended resource type
function resource.set(path, buffer) end

---Sets the data for a specific atlas resource. Setting new atlas data is specified by passing in
---a texture path for the backing texture of the atlas, a list of geometries and a list of animations
---that map to the entries in the geometry list. The geometry entries are represented by three lists:
---vertices, uvs and indices that together represent triangles that are used in other parts of the
---engine to produce render objects from.
---Vertex and uv coordinates for the geometries are expected to be
---in pixel coordinates where 0,0 is the top left corner of the texture.
---There is no automatic padding or margin support when setting custom data,
---which could potentially cause filtering artifacts if used with a material sampler that has linear filtering.
---If that is an issue, you need to calculate padding and margins manually before passing in the geometry data to
---this function.
---@param path hash|string The path to the atlas resource
---@param table resource.atlas A table containing info about the atlas. Supported entries:
---
---
---
---texture
---string | hash the path to the texture resource, e.g "/main/my_texture.texturec"
---
---
---
---
---animations
---table a list of the animations in the atlas. Supports the following fields:
---
---
---
---
---id
---string the id of the animation, used in e.g sprite.play_animation
---
---
---
---
---width
---integer the width of the animation
---
---
---
---
---height
---integer the height of the animation
---
---
---
---
---frame_start
---integer index to the first geometry of the animation. Indices are lua based and must be in the range of 1 ..  in atlas.
---
---
---
---
---frame_end
---integer index to the last geometry of the animation (non-inclusive). Indices are lua based and must be in the range of 1 ..  in atlas.
---
---
---
---
---playback
---constant optional playback mode of the animation, the default value is go.PLAYBACK_ONCE_FORWARD
---
---
---
---
---fps
---integer optional fps of the animation, the default value is 30
---
---
---
---
---flip_vertical
---boolean optional flip the animation vertically, the default value is false
---
---
---
---
---flip_horizontal
---boolean optional flip the animation horizontally, the default value is false
---
---
---
---
---geometries
---table A list of the geometries that should map to the texture data. Supports the following fields:
---
---
---
---
---vertices
---table a list of the vertices in texture space of the geometry in the form {px0, py0, px1, py1, ..., pxn, pyn}
---
---
---
---
---uvs
---table a list of the uv coordinates in texture space of the geometry in the form of {u0, v0, u1, v1, ..., un, vn}
---
---
---
---
---indices
---table a list of the indices of the geometry in the form {i0, i1, i2, ..., in}. Each tripe in the list represents a triangle.
---
---
---
function resource.set_atlas(path, table) end

---Sets the buffer of a resource. By default, setting the resource buffer will either copy the data from the incoming buffer object
---to the buffer stored in the destination resource, or make a new buffer object if the sizes between the source buffer and the destination buffer
---stored in the resource differs. In some cases, e.g performance reasons, it might be beneficial to just set the buffer object on the resource without copying or cloning.
---To achieve this, set the transfer_ownership flag to true in the argument table. Transferring ownership from a lua buffer to a resource with this function
---works exactly the same as resource.create_buffer: the destination resource will take ownership of the buffer held by the lua reference, i.e the buffer will not automatically be removed
---when the lua reference to the buffer is garbage collected.
---Note: When setting a buffer with transfer_ownership = true, the currently bound buffer in the resource will be destroyed.
---@param path hash|string The path to the resource
---@param buffer buffer_data The resource buffer
---@param table { transfer_ownership: boolean|nil }|nil A table containing info about how to set the buffer. Supported entries:
---
---
---
---transfer_ownership
---boolean optional flag to determine wether or not the resource should take over ownership of the buffer object (default false)
---
---
---
function resource.set_buffer(path, buffer, table) end

---Update internal sound resource (wavc/oggc) with new data
---@param path hash|string The path to the resource
---@param buffer string A lua string containing the binary sound data
function resource.set_sound(path, buffer) end

---Sets the pixel data for a specific texture.
---@param path hash|string The path to the resource
---@param table { type:number, width:number, height:number, format:number, x:number|nil, y:number|nil, mipmap:number|nil, compression_type:number|nil} A table containing info about the texture. Supported entries:
---
---type
---number The texture type. Supported values:
---
---
---resource.TEXTURE_TYPE_2D
---resource.TEXTURE_TYPE_CUBE_MAP
---
---
---width
---number The width of the texture (in pixels)
---height
---number The width of the texture (in pixels)
---format
---number The texture format, note that some of these formats are platform specific. Supported values:
---
---
---resource.TEXTURE_FORMAT_LUMINANCE
---resource.TEXTURE_FORMAT_RGB
---resource.TEXTURE_FORMAT_RGBA
---
---These constants might not be available on the device:
---- resource.TEXTURE_FORMAT_RGB_PVRTC_2BPPV1
---- resource.TEXTURE_FORMAT_RGB_PVRTC_4BPPV1
---- resource.TEXTURE_FORMAT_RGBA_PVRTC_2BPPV1
---- resource.TEXTURE_FORMAT_RGBA_PVRTC_4BPPV1
---- resource.TEXTURE_FORMAT_RGB_ETC1
---- resource.TEXTURE_FORMAT_RGBA_ETC2
---- resource.TEXTURE_FORMAT_RGBA_ASTC_4x4
---- resource.TEXTURE_FORMAT_RGB_BC1
---- resource.TEXTURE_FORMAT_RGBA_BC3
---- resource.TEXTURE_FORMAT_R_BC4
---- resource.TEXTURE_FORMAT_RG_BC5
---- resource.TEXTURE_FORMAT_RGBA_BC7
---- resource.TEXTURE_FORMAT_RGB16F
---- resource.TEXTURE_FORMAT_RGB32F
---- resource.TEXTURE_FORMAT_RGBA16F
---- resource.TEXTURE_FORMAT_RGBA32F
---- resource.TEXTURE_FORMAT_R16F
---- resource.TEXTURE_FORMAT_RG16F
---- resource.TEXTURE_FORMAT_R32F
---- resource.TEXTURE_FORMAT_RG32F
---You can test if the device supports these values by checking if a specific enum is nil or not:
---if resource.TEXTURE_FORMAT_RGBA16F ~= nil then
---    -- it is safe to use this format
---end
---
---
---
---x
---number optional x offset of the texture (in pixels)
---y
---number optional y offset of the texture (in pixels)
---mipmap
---number optional mipmap to upload the data to
---compression_type
---number optional specify the compression type for the data in the buffer object that holds the texture data. Defaults to resource.COMPRESSION_TYPE_DEFAULT, i.e no compression. Supported values:
---
---
---COMPRESSION_TYPE_DEFAULT
---COMPRESSION_TYPE_BASIS_UASTC
---
---@param buffer buffer_data The buffer of precreated pixel data
--- To update a cube map texture you need to pass in six times the amount of data via the buffer, since a cube map has six sides!
function resource.set_texture(path, table, buffer) end

---Constructor-like function with two purposes:
---Load the specified resource as part of loading the script
---Return a hash to the run-time version of the resource
--- This function can only be called within go.property function calls.
---@param path string|nil optional resource path string to the resource
---@return hash path a path hash to the binary version of the resource
function resource.texture(path) end

---Constructor-like function with two purposes:
---Load the specified resource as part of loading the script
---Return a hash to the run-time version of the resource
--- This function can only be called within go.property function calls.
---@param path string|nil optional resource path string to the resource
---@return hash path a path hash to the binary version of the resource
function resource.tile_source(path) end

return resource