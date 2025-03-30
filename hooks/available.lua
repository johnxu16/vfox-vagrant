local http = require("http")

--- Return all available versions provided by this plugin
--- @param ctx table Empty table used as context, for future extension
--- @return table Descriptions of available versions and accompanying tool descriptions
function PLUGIN:Available(ctx)
    local resp, err = http.get({
        url = "https://releases.hashicorp.com/vagrant"
    })

    if err ~= nil then
        error("Failed to get information: " .. err)
    end
    if resp.status_code ~= 200 then
        error("Failed to get information: status_code =>" .. resp.status_code)
    end

    local result = {}

    for s in resp.body:gmatch("([^\n]*)\n?") do
        local i, j = string.find(s, "vagrant_%d+.%d+.%d+")
        if i ~= nil then
            local version = string.sub(s, i, j)
            version = string.gsub(version, "vagrant_", "")

            table.insert(result, {
                version = version
            })
        end
    end

    return result
end
