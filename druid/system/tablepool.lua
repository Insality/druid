-- Source: https://github.com/openresty/lua-tablepool/blob/master/lib/tablepool.lua

local setmetatable = setmetatable

local _M = {}
local max_pool_size = 500
local pools = {}


function _M.fetch(tag)
    local pool = pools[tag]
    if not pool then
        pool = {}
        pools[tag] = pool
        pool.c = 0
        pool[0] = 0

    else
        local len = pool[0]
        if len > 0 then
            local obj = pool[len]
            pool[len] = nil
            pool[0] = len - 1
            return obj
        end
    end

    return {}
end


function _M.release(tag, obj, noclear)
    if not obj then
        error("object empty", 2)
    end

    local pool = pools[tag]
    if not pool then
        pool = {}
        pools[tag] = pool
        pool.c = 0
        pool[0] = 0
    end

    if not noclear then
        setmetatable(obj, nil)
        for k in pairs(obj) do
            obj[k] = nil
        end
    end

    do
        local cnt = pool.c + 1
        if cnt >= 20000 then
            pool = {}
            pools[tag] = pool
            pool.c = 0
            pool[0] = 0
            return
        end
        pool.c = cnt
    end

    local len = pool[0] + 1
    if len > max_pool_size then
        -- discard it simply
        return
    end

    pool[len] = obj
    pool[0] = len
end


return _M
