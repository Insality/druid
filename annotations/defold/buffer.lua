--[[
  Generated with github.com/astrochili/defold-annotations
  Defold 1.8.0

  Buffer API documentation

  Functions for manipulating buffers and streams
--]]

---@diagnostic disable: lowercase-global
---@diagnostic disable: missing-return
---@diagnostic disable: duplicate-doc-param
---@diagnostic disable: duplicate-set-field

---@class defold_api.buffer
buffer = {}

---Float, single precision, 4 bytes
buffer.VALUE_TYPE_FLOAT32 = nil

---Signed integer, 2 bytes
buffer.VALUE_TYPE_INT16 = nil

---Signed integer, 4 bytes
buffer.VALUE_TYPE_INT32 = nil

---Signed integer, 8 bytes
buffer.VALUE_TYPE_INT64 = nil

---Signed integer, 1 byte
buffer.VALUE_TYPE_INT8 = nil

---Unsigned integer, 2 bytes
buffer.VALUE_TYPE_UINT16 = nil

---Unsigned integer, 4 bytes
buffer.VALUE_TYPE_UINT32 = nil

---Unsigned integer, 8 bytes
buffer.VALUE_TYPE_UINT64 = nil

---Unsigned integer, 1 byte
buffer.VALUE_TYPE_UINT8 = nil

---Copy all data streams from one buffer to another, element wise.
--- Each of the source streams must have a matching stream in the
---destination buffer. The streams must match in both type and size.
---The source and destination buffer can be the same.
---@param dst buffer_data the destination buffer
---@param dstoffset number the offset to start copying data to
---@param src buffer_data the source data buffer
---@param srcoffset number the offset to start copying data from
---@param count number the number of elements to copy
function buffer.copy_buffer(dst, dstoffset, src, srcoffset, count) end

---Copy a specified amount of data from one stream to another.
--- The value type and size must match between source and destination streams.
---The source and destination streams can be the same.
---@param dst buffer_stream the destination stream
---@param dstoffset number the offset to start copying data to (measured in value type)
---@param src buffer_stream the source data stream
---@param srcoffset number the offset to start copying data from (measured in value type)
---@param count number the number of values to copy (measured in value type)
function buffer.copy_stream(dst, dstoffset, src, srcoffset, count) end

---Create a new data buffer containing a specified set of streams. A data buffer
---can contain one or more streams with typed data. This is useful for managing
---compound data, for instance a vertex buffer could contain separate streams for
---vertex position, color, normal etc.
---@param element_count number The number of elements the buffer should hold
---@param declaration { name:hash|string, type:constant, count:number }[] A table where each entry (table) describes a stream
---
---hash | string name: The name of the stream
---constant type: The data type of the stream
---number count: The number of values each element should hold
---
---@return buffer_data buffer the new buffer
function buffer.create(element_count, declaration) end

---Get a copy of all the bytes from a specified stream as a Lua string.
---@param buffer buffer_data the source buffer
---@param stream_name hash the name of the stream
---@return string data the buffer data as a Lua string
function buffer.get_bytes(buffer, stream_name) end

---Get a named metadata entry from a buffer along with its type.
---@param buf buffer_data the buffer to get the metadata from
---@param metadata_name hash|string name of the metadata entry
---@return number[]|nil values table of metadata values or nil if the entry does not exist
---@return constant|nil value_type numeric type of values or nil
function buffer.get_metadata(buf, metadata_name) end

---Get a specified stream from a buffer.
---@param buffer buffer_data the buffer to get the stream from
---@param stream_name hash|string the stream name
---@return buffer_stream stream the data stream
function buffer.get_stream(buffer, stream_name) end

---Creates or updates a metadata array entry on a buffer.
--- The value type and count given when updating the entry should match those used when first creating it.
---@param buf buffer_data the buffer to set the metadata on
---@param metadata_name hash|string name of the metadata entry
---@param values number[] actual metadata, an array of numeric values
---@param value_type constant type of values when stored
function buffer.set_metadata(buf, metadata_name, values, value_type) end

return buffer