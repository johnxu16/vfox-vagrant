local util = require("util")
--- Extension point, called after PreInstall, can perform additional operations,
--- such as file operations for the SDK installation directory or compile source code
--- Currently can be left unimplemented!
function PLUGIN:PostInstall(ctx)
    --- ctx.rootPath SDK installation directory
    local sdkInfo = ctx.sdkInfo['vagrant']
    local path = sdkInfo.path

    local osType = RUNTIME.osType
    local archType = RUNTIME.archType

    if osType == "windows" then
        local installer
        local logPath = path .. "\\install.log"
        local installPath = path .. "\\release"
        if RUNTIME.archType == "amd64" then
            installer = path .. "\\vagrant_" .. sdkInfo.version .. "_windows_" .. archType .. ".msi"
        else
            installer = path .. "\\vagrant_" .. sdkInfo.version .. "_windows_" .. archType .. ".msi"
        end

        -- local install_cmd =
        -- [[msiexec.exe /i C:\Users\11633\.version-fox\cache\vagrant\v-2.4.3\vagrant-2.4.3\vagrant_2.4.3_windows_amd64.msi /norestart /L*V C:\Users\11633\.version-fox\cache\vagrant\v-2.4.3\vagrant-2.4.3\install.log LicenseAccepted=1 CostingComplete=1 INSTALLDIR=C:\Users\11633\.version-fox\cache\vagrant\v-2.4.3\vagrant-2.4.3\release]]
        local install_cmd = "sudo msiexec.exe /i " ..
            installer ..
            " /qn /norestart /L*V " ..
            logPath ..
            " LicenseAccepted=1 CostingComplete=1 " ..
            "INSTALLDIR=" .. installPath
        print("Install vagrant with script: \r\n", install_cmd)
        local status = os.execute(install_cmd)
        if status ~= 0 then
            error("Vagrant install failed, please check the install.log for details.")
        end

        print("Please wait till the installing ends...")
        -- Verify installation status
        local binPath = installPath .. "\\bin"
        -- local vagrantPath = binPath .. "\\vagrant"
        local installFinished = util:run_interval(6, 30, function()
            local resp
            while true do
                resp = util:exists(binPath)
                if resp then
                    break
                end
                coroutine.yield()
            end
            return resp
        end)
        if installFinished ~= true then
            error("Vagrant install failed or timeout")
        end

        -- TODO: Remove default system env path set by Installer
    end
end
