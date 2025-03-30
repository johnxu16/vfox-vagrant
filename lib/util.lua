local util = {}

function util:run_interval(interval, maxTrial, func)
    local co = coroutine.create(func)
    local res

    for _ = 1, maxTrial do
        -- Run the coroutine
        local status, resp = coroutine.resume(co)

        if not status then
            -- print("Coroutine error: ", err)
            break
        end

        res = resp

        os.execute("timeout /t " .. interval .. " > NUL")

        -- For Unix-based systems:
        -- os.execute("sleep " .. interval)
    end

    return res
end

function util:exists(file)
    local ok, err, code = os.rename(file, file)
    if not ok then
        if code == 13 then
            -- Permission denied, but it exists
            return true
        end
    end
    return ok, err
end

return util
