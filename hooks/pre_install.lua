local http = require("http")
local json = require("json")
local strings = require("vfox.strings")

--- Returns some pre-installed information, such as version number, download address, local files, etc.
--- If checksum is provided, vfox will automatically check it for you.
--- @param ctx table
--- @field ctx.version string User-input version
--- @return table Version information
function PLUGIN:PreInstall(ctx)
    local version = ctx.version
    local osType = RUNTIME.osType
    local archType = RUNTIME.archType

    if osType == "darwin" then
        error("MacOS is currently not supported")
    end

    local metaURL = "https://api.releases.hashicorp.com/v1/releases/vagrant/" .. version .. "/"
    local metaResp, err = http.get({ url = metaURL })

    if err ~= nil or metaResp.status_code ~= 200 then
        error("get build meta data failed")
    end

    local metaBody = json.decode(metaResp.body)

    local builds = metaBody["builds"]

    -- find target build
    local targetBuild

    for _, build in ipairs(builds) do
        local url = build["url"]
        -- Only support .zip .msi files
        if osType == build["os"] and archType == build["arch"] and (strings.has_suffix(url, ".zip") or strings.has_suffix(url, ".msi")) then
            targetBuild = build
        end
    end

    -- TODO: sha
    -- local shaURL = metaBody["url_shasums"]
    -- local shaResp, shaErr = http.get({ url = shaURL })

    -- if shaErr ~= nil or shaResp.status_code ~= 200 then
    --     error("get sha file failed")
    -- end

    -- local shaBody = shaResp.body

    local download_url = targetBuild["url"]
    print("Download vagrant from " .. download_url)

    return {
        version = version,
        url = download_url
    }
end
