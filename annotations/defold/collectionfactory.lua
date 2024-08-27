--[[
  Generated with github.com/astrochili/defold-annotations
  Defold 1.8.0

  Collection factory API documentation

  Functions for controlling collection factory components which are
  used to dynamically spawn collections into the runtime.
--]]

---@diagnostic disable: lowercase-global
---@diagnostic disable: missing-return
---@diagnostic disable: duplicate-doc-param
---@diagnostic disable: duplicate-set-field

---@class defold_api.collectionfactory
collectionfactory = {}

---loaded
collectionfactory.STATUS_LOADED = nil

---loading
collectionfactory.STATUS_LOADING = nil

---unloaded
collectionfactory.STATUS_UNLOADED = nil

---The URL identifies the collectionfactory component that should do the spawning.
---Spawning is instant, but spawned game objects get their first update calls the following frame. The supplied parameters for position, rotation and scale
---will be applied to the whole collection when spawned.
---Script properties in the created game objects can be overridden through
---a properties-parameter table. The table should contain game object ids
---(hash) as keys and property tables as values to be used when initiating each
---spawned game object.
---See go.property for more information on script properties.
---The function returns a table that contains a key for each game object
---id (hash), as addressed if the collection file was top level, and the
---corresponding spawned instance id (hash) as value with a unique path
---prefix added to each instance.
--- Calling collectionfactory.create create on a collection factory that is marked as dynamic without having loaded resources
---using collectionfactory.load will synchronously load and create resources which may affect application performance.
---@param url string|hash|url the collection factory component to be used
---@param position vector3|nil position to assign to the newly spawned collection
---@param rotation quaternion|nil rotation to assign to the newly spawned collection
---@param properties table|nil table of script properties to propagate to any new game object instances
---@param scale number|nil uniform scaling to apply to the newly spawned collection (must be greater than 0).
---@return table<string|hash, string|hash> ids a table mapping the id:s from the collection to the new instance id:s
function collectionfactory.create(url, position, rotation, properties, scale) end

---This returns status of the collection factory.
---Calling this function when the factory is not marked as dynamic loading always returns COMP_COLLECTION_FACTORY_STATUS_LOADED.
---@param url string|hash|url|nil the collection factory component to get status from
---@return constant status status of the collection factory component
---
---collectionfactory.STATUS_UNLOADED
---collectionfactory.STATUS_LOADING
---collectionfactory.STATUS_LOADED
---
function collectionfactory.get_status(url) end

---Resources loaded are referenced by the collection factory component until the existing (parent) collection is destroyed or collectionfactory.unload is called.
---Calling this function when the factory is not marked as dynamic loading does nothing.
---@param url string|hash|url|nil the collection factory component to load
---@param complete_function fun(self, url, result)|nil function to call when resources are loaded.
---
---self
---object The current object.
---url
---url url of the collection factory component
---result
---boolean True if resource were loaded successfully
---
function collectionfactory.load(url, complete_function) end

---Changes the prototype for the collection factory.
---Setting the prototype to "nil" will revert back to the original prototype.
---@param url string|hash|url|nil the collection factory component
---@param prototype string|nil the path to the new prototype, or nil
function collectionfactory.set_prototype(url, prototype) end

---This decreases the reference count for each resource loaded with collectionfactory.load. If reference is zero, the resource is destroyed.
---Calling this function when the factory is not marked as dynamic loading does nothing.
---@param url string|hash|url|nil the collection factory component to unload
function collectionfactory.unload(url) end

return collectionfactory