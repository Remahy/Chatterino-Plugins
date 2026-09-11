function OptionalChain(obj, ...)
    for _, value in ipairs({ ... }) do
        obj = obj[value]
        if not obj then return nil end
    end
    return obj
end
