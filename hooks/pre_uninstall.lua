--- This is called before the SDK is uninstalled.
--- @param ctx table Context information
function PLUGIN:PreUninstall(ctx)
  local sdkInfo = ctx.main
  local path = sdkInfo.path
  -- local version = sdkInfo.version
  -- local name = sdkInfo.name

  local osType = RUNTIME.osType
  local archType = RUNTIME.archType

  if osType == "windows" then
    local installer
    if RUNTIME.archType == "amd64" then
      installer = path .. "\\vagrant_" .. sdkInfo.version .. "_windows_" .. archType .. ".msi"
    else
      installer = path .. "\\vagrant_" .. sdkInfo.version .. "_windows_" .. archType .. ".msi"
    end

    local uninstall_cmd = "sudo msiexec.exe /x " ..
        installer ..
        " /qn /norestart"
    print("Uninstall vagrant with script: \r\n", uninstall_cmd)
    local status = os.execute(uninstall_cmd)
    if status ~= 0 then
      error("Vagrant install failed, please check the install.log for details.")
    end
  end
end
